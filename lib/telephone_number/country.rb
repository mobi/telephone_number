module TelephoneNumber
  class Country
    attr_reader :country_code, :national_prefix, :national_prefix_formatting_rule,
                :national_prefix_for_parsing, :national_prefix_transform_rule, :international_prefix,
                :formats, :validations, :mobile_token, :country_id, :general_validation, :main_country_for_code

    MOBILE_TOKEN_COUNTRIES = { AR: '9' }

    def initialize(data_hash)
      @country_code = data_hash[:country_code]
      @country_id = data_hash[:id]
      @formats = data_hash.fetch(:formats, []).map { |format| NumberFormat.new(format) }
      @general_validation = NumberValidation.new(:general_desc, data_hash[:validations][:general_desc]) if data_hash.fetch(:validations, {})[:general_desc]
      @international_prefix = Regexp.new(data_hash[:international_prefix]) if data_hash[:international_prefix]
      @main_country_for_code = data_hash[:main_country_for_code] == 'true'
      @mobile_token = MOBILE_TOKEN_COUNTRIES[@country_id.to_sym]
      @national_prefix = data_hash[:national_prefix]
      @national_prefix_formatting_rule = data_hash[:national_prefix_formatting_rule]
      @national_prefix_for_parsing = Regexp.new(data_hash[:national_prefix_for_parsing]) if data_hash[:national_prefix_for_parsing]
      @national_prefix_transform_rule = data_hash[:national_prefix_transform_rule]
      @validations = data_hash.fetch(:validations, {})
                              .except(:general_desc, :area_code_optional)
                              .map { |name, data| NumberValidation.new(name, data) }
    end

    def detect_format(number)
      native_format = formats.detect do |format|
        number =~ Regexp.new("^(#{format.leading_digits})") && number =~ Regexp.new("^(#{format.pattern})$")
      end

      return native_format if native_format || main_country_for_code
      parent_country.detect_format(number) if parent_country
    end

    def parent_country
      return if main_country_for_code
      Country.all_countries.detect do |country|
        country.country_code == self.country_code && country.main_country_for_code
      end
    end

    def full_general_pattern
      %r{^(#{country_code})?(#{national_prefix})?(?<national_num>#{general_validation.pattern})$}
    end

    def self.phone_data
      @phone_data ||= load_data
    end

    def self.find(country_id)
      data = phone_data[country_id.to_s.upcase.to_sym]
      new(data) if data
    end

    def self.load_data
      data_file = "#{File.dirname(__FILE__)}/../../data/telephone_number_data_file.dat"
      main_data = Marshal.load(File.binread(data_file))
      override_data = {}
      override_data = Marshal.load(File.binread(TelephoneNumber.override_file)) if TelephoneNumber.override_file
      return main_data.deep_deep_merge!(override_data)
    end

    def self.all_countries
      @all_countries ||= phone_data.values.map {|data| new(data)}
    end
  end
end
