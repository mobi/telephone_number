module TelephoneNumber
  class PhoneData
    AREA_CODE_OPTIONAL = :area_code_optional
    COUNTRY_CODE = :country_code
    FIXED_LINE = :fixed_line
    FORMATS = :formats
    FORMAT = :format
    GENERAL = :general_desc
    INTERNATIONAL_PREFIX = :international_prefix
    INTL_FORMAT = :intl_format
    LEADING_DIGITS = :leading_digits
    MAIN_COUNTRY_FOR_CODE = :main_country_for_code
    MOBILE = :mobile
    MOBILE_TOKEN_COUNTRIES = { AR: '9' }.freeze
    NATIONAL_PREFIX = :national_prefix
    NATIONAL_PREFIX_FOR_PARSING = :national_prefix_for_parsing
    NATIONAL_PREFIX_FORMATTING_RULE = :national_prefix_formatting_rule
    NO_INTERNATIONAL_DIALING = :no_international_dialling
    PATTERN = :pattern
    PERSONAL_NUMBER = :personal_number
    POSSIBLE_PATTERN = :possible_number_pattern
    PREMIUM_RATE = :premium_rate
    SHARED_COST = :shared_cost
    TOLL_FREE = :toll_free
    UAN = :uan
    VALIDATIONS = :validations
    VALID_PATTERN = :national_number_pattern
    VOICEMAIL = :voicemail
    VOIP = :voip

    attr_reader :country_data, :country

    def self.phone_data
      @@phone_data ||= load_data
    end

    def self.load_data
      data_file = "#{File.dirname(__FILE__)}/../../data/telephone_number_data_file.dat"
      main_data = Marshal.load(File.binread(data_file))
      override_data = {}
      override_data = Marshal.load(File.binread(TelephoneNumber.override_file)) if TelephoneNumber.override_file
      return main_data.deep_deep_merge!(override_data)
    end

    def initialize(country)
      @country = country.to_s.upcase.to_sym
      @country_data = self.class.phone_data[@country]
    end
  end
end

