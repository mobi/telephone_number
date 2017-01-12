module TelephoneNumber
  module PhoneData
    VALIDATIONS = :validations.freeze
    FORMATS = :formats.freeze
    GENERAL = :general_desc.freeze
    PREMIUM_RATE = :premium_rate.freeze
    TOLL_FREE = :toll_free.freeze
    SHARED_COST = :shared_cost.freeze
    VOIP = :voip.freeze
    PERSONAL_NUMBER = :personal_number.freeze
    UAN = :uan.freeze
    VOICEMAIL = :voicemail.freeze
    FIXED_LINE = :fixed_line.freeze
    MOBILE = :mobile.freeze
    NO_INTERNATIONAL_DIALING = :no_international_dialling.freeze
    AREA_CODE_OPTIONAL = :area_code_optional.freeze
    VALID_PATTERN = :national_number_pattern.freeze
    POSSIBLE_PATTERN = :possible_number_pattern.freeze
    NATIONAL_PREFIX = :national_prefix.freeze
    COUNTRY_CODE = :country_code.freeze
    LEADING_DIGITS = :leading_digits.freeze
    INTERNATIONAL_PREFIX = :international_prefix.freeze

    def self.phone_data
      @@phone_data ||= load_data
    end

    def self.load_data
      data_file = "#{File.dirname(__FILE__)}/../../data/telephone_number_data_file.dat"
      main_data = Marshal.load(File.binread(data_file))
      override_data = {}
      override_data = Marshal.load(File.binread(TelephoneNumber.override_file)) if TelephoneNumber.override_file
      return main_data.merge!(override_data)
    end
  end
end

