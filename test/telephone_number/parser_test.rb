require "test_helper"

module TelephoneNumber
  class ParserTest < Minitest::Test
    def setup
      @valid_numbers = YAML.load_file('test/valid_numbers.yml')
      @invalid_numbers = YAML.load_file('test/invalid_numbers.yml')
    end

    def test_sanitize_removes_all_non_numeric_characters
      numbers = %w(555$$@@5555555 ##$#%#5555555555)
      numbers.each do |number|
        telephone_number = TelephoneNumber.parse(number, 'US')
        assert_equal '5555555555', telephone_number.sanitize(number)
      end
    end

    def test_validate_numbers_for_valid_numbers_in_countries
      @valid_numbers.each do |country, number_object|
        number_object.each do |_name, number_data|
          number_data.each do |_type, number|
            refute_predicate TelephoneNumber.parse(number, country).validate, :empty?
          end
        end
      end
    end

    def test_validate_numbers_for_invalid_numbers_in_countries
      @invalid_numbers.each do |country, number_object|
        number_object.each do |_name, number_data|
          number_data.each do |_type, number|
            assert_predicate TelephoneNumber.parse(number, country).validate, :empty?
          end
        end
      end
    end
  end
end
