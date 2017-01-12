module TelephoneNumber
  class Number
    include TelephoneNumber::Parser

    attr_reader :original_number, :country, :e164_number, :national_number

    def initialize(number, country)
      return unless number && country

      @original_number = sanitize(number)
      @country = country.upcase.to_sym
      @national_number, @e164_number = extract_number_types(@original_number, @country)
    end

    def valid_types
      @valid_types ||= validate(e164_number, country)
    end

    def valid?(keys = [])
      keys.empty? ? !valid_types.empty? : !(valid_types & keys.map(&:to_sym)).empty?
    end

    def format
      @format ||= extract_format(national_number, country)
    end
  end
end
