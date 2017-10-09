require "test_helper"

module TelephoneNumber
  class NumberTest < Minitest::Test

    def setup
      @valid_numbers = YAML.load_file('test/valid_numbers.yml')
    end

    def test_detects_country_if_nil
      @valid_numbers.each do |country, number_object|
        number_object.each do |_name, number_data|
          detected_country = TelephoneNumber::Number.new(number_data[:e164_formatted], nil).country.country_id
          assert_equal country.to_s, detected_country
        end
      end
    end

    def test_country_is_nil_with_invalid_input
      detected_country = TelephoneNumber::Number.new('13175083384', 'NOTREAL').country
      assert_nil detected_country
    end
  end
end
