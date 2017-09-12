module TelephoneNumber
  class Number
    extend Forwardable

    attr_reader :country, :parser, :formatter, :original_number

    delegate [:valid?, :valid_types, :normalized_number] => :parser
    delegate [:national_number, :e164_number, :international_number] => :formatter
    delegate [:country_data, :country] => :phone_data

    def initialize(number, country)
      @original_number = number
      @country = Country.find(country)
      @parser = Parser.new(self)
      @formatter = Formatter.new(self)
    end
  end
end
