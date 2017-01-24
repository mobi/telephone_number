require 'test_helper'

module TelephoneNumber
  class FormatterTest < Minitest::Test
    def setup
      @valid_numbers = YAML.load_file('test/valid_numbers.yml')
      @invalid_numbers = YAML.load_file('test/invalid_numbers.yml')
    end

    def test_valid_formatted_national_number_for_countries
      @valid_numbers.each do |country, number_object|
        number_object.values.each do |number_data|
          number_data.values.each do |number|
            telephone_number = TelephoneNumber.parse(number, country)
            assert_equal number_data[:national_formatted], telephone_number.national_number
          end
        end
      end
    end

    def test_invalid_formatted_national_number_for_countries
      @invalid_numbers.each do |country, number_object|
        number_object.values.each do |number_data|
          number_data.values.each do |number|
            telephone_number = TelephoneNumber.parse(number, country)
            assert_equal number_data[:national_formatted], telephone_number.national_number
          end
        end
      end
    end
  end
end
