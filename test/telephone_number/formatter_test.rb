require 'test_helper'

module TelephoneNumber
  class FormatterTest < Minitest::Test
    def setup
      @valid_numbers = YAML.load_file('test/valid_numbers.yml')
      @invalid_numbers = YAML.load_file('test/invalid_numbers.yml')
    end

    def test_returns_empty_string_if_input_is_nil
      country_inputs = [nil, '', :us]
      number_inputs = [nil, '']
      methods = [:international_number, :national_number, :e164_number]

      country_inputs.product(number_inputs, methods).each do |country, number, method|
        assert_equal '', TelephoneNumber.parse(number, country).public_send(method)
      end
    end

    def test_returns_sanitized_string_when_country_is_nil
      assert_equal '3175082205', TelephoneNumber.parse('3175082205', nil).international_number
      assert_equal '3175082205', TelephoneNumber.parse('3175082205', nil).national_number
      assert_equal '3175082205', TelephoneNumber.parse('3175082205', nil).e164_number
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

    def test_valid_formatted_international_number_for_countries
      @valid_numbers.each do |country, number_object|
        number_object.values.each do |number_data|
          number_data.values.each do |number|
            telephone_number = TelephoneNumber.parse(number, country)
            assert_equal number_data[:international_formatted], telephone_number.international_number
          end
        end
      end
    end

    def test_valid_formatted_e164_numbers_for_countries
      @valid_numbers.each do |country, number_object|
        number_object.values.each do |number_data|
          number_data.values.each do |number|
            telephone_number = TelephoneNumber.parse(number, country)
            assert_equal number_data[:e164_formatted], telephone_number.e164_number
          end
        end
      end
    end

    def test_invalid_numbers_go_to_default_pattern
      TelephoneNumber.default_format_pattern = "(\\d{3})(\\d{3})(\\d*)"
      TelephoneNumber.default_format_string = "($1) $2-$3"
      invalid_number = "1111111111"
      assert_equal "(111) 111-1111", TelephoneNumber.parse(invalid_number, :us).national_number

      TelephoneNumber.class_variable_set(:@@default_format_pattern, nil)
      TelephoneNumber.class_variable_set(:@@default_format_string, nil)
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
