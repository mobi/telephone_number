module TelephoneNumber
  module ClassMethods
    attr_accessor :override_file, :default_format_string
    attr_reader :default_format_pattern

    def default_format_pattern=(format_string)
      @default_format_pattern = Regexp.new(format_string)
    end

    def parse(number, country = detect_country(number))
      TelephoneNumber::Number.new(sanitize(number), country)
    end

    def valid?(number, country = detect_country(number), keys = [])
      parse(number, country).valid?(keys)
    end

    def invalid?(*args)
      !valid?(*args)
    end

    def sanitize(input_number)
      input_number.to_s.gsub(/\D/, '')
    end

    def detect_country(number)
      sanitized_number = sanitize(number)
      detected_country = Country.all_countries.detect do |country|
        sanitized_number.start_with?(country.country_code) && valid?(sanitized_number, country.country_id)
      end

      detected_country.country_id.to_sym if detected_country
    end

    # generates binary file from xml that user gives us
    def generate_override_file(file)
      DataImporter.new(file, override: true).import!
    end
  end
end
