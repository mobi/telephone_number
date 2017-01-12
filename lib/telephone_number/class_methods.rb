module TelephoneNumber
  module ClassMethods
    def parse(number, country)
      TelephoneNumber::Number.new(number, country)
    end

    def valid?(number, country, keys = [])
      parse(number, country).valid?(keys)
    end
  end
end
