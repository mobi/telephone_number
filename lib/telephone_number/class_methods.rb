module TelephoneNumber
  module ClassMethods
    attr_accessor :override_file, :default_format_string
    attr_reader :default_format_pattern

    def default_format_pattern=(format_string)
      @default_format_pattern = Regexp.new(format_string)
    end

    def parse(number, country = Parser.detect_country(number))
      TelephoneNumber::Number.new(number, country)
    end

    def valid?(number, country = Parser.detect_country(number), keys = [])
      parse(number, country).valid?(keys)
    end

    def invalid?(*args)
      !valid?(*args)
    end

    # generates binary file from xml that user gives us
    def generate_override_file(file)
      DataImporter.new(file, override: true).import!
    end
  end
end
