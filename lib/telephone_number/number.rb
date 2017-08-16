module TelephoneNumber
  class Number
    extend Forwardable

    attr_reader :phone_data, :parser, :formatter

    delegate [:valid?, :valid_types, :normalized_number] => :parser
    delegate [:national_number, :e164_number, :international_number] => :formatter
    delegate [:country_data, :country] => :phone_data

    def initialize(number, country)
      @phone_data = PhoneData.new(country)
      @parser = Parser.new(number, @phone_data)
      @formatter = Formatter.new(self, @phone_data)
    end
  end
end
