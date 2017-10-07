module TelephoneNumber
  class Number
    extend Forwardable

    attr_reader :country, :parser, :formatter, :original_number, :geo_locator

    delegate [:valid?, :valid_types, :normalized_number] => :parser
    delegate [:national_number, :e164_number, :international_number] => :formatter

    def initialize(number, country = nil)
      @original_number = TelephoneNumber.sanitize(number)
      @country = country ? Country.find(country) : detect_country
      @parser = Parser.new(self)
      @formatter = Formatter.new(self)
    end

    def location(locale = :en)
      @geo_locator ||= GeoLocator.new(self, locale)
      @geo_locator.location
    end

    private

    def detect_country
      # note that it is entirely possible for two separate countries to use the same
      # validation scheme. Take Italy and Vatican City for example.
      eligible_countries = Country.all_countries.select do |country|
        original_number.start_with?(country.country_code) && self.class.new(original_number, country.country_id).valid?
      end

      detected_country = eligible_countries.detect(&:main_country_for_code) || eligible_countries.first
      Country.find(detected_country.country_id.to_sym) if detected_country
    end
  end
end
