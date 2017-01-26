module TelephoneNumber
  class Number
    include TelephoneNumber::Parser
    include TelephoneNumber::Formatter

    attr_reader :original_number, :normalized_number, :country, :country_data

    def initialize(number, country)
      return unless number && country

      @original_number = sanitize(number).freeze
      @country = country.upcase.to_sym
      @country_data = TelephoneNumber::PhoneData.phone_data[@country]

      # normalized_number is basically a "best effort" at national number without
      # any formatting. This is what we will use to derive formats, validations and
      # basically anything else that uses google data
      @normalized_number = build_normalized_number
    end

    def valid_types
      @valid_types ||= validate
    end

    def valid?(keys = [])
      keys.empty? ? !valid_types.empty? : !(valid_types & keys.map(&:to_sym)).empty?
    end

    def national_number
      @formatted_national_number ||= formatted_national_number
    end

    private

    def format
      @format ||= extract_format
    end
  end
end
