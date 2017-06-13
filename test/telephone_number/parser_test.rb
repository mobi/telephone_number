require "test_helper"

module TelephoneNumber
  class ParserTest < Minitest::Test
    def setup
      @valid_numbers = YAML.load_file('test/valid_numbers.yml')
      @invalid_numbers = YAML.load_file('test/invalid_numbers.yml')
    end

    def test_validate_numbers_for_valid_numbers_in_countries
      @valid_numbers.each do |country, number_object|
        number_object.each do |_name, number_data|
          number_data.each do |_type, number|
            refute_predicate TelephoneNumber.parse(number, country).valid_types, :empty?
          end
        end
      end
    end

    def test_validate_numbers_for_invalid_numbers_in_countries
      @invalid_numbers.each do |country, number_object|
        number_object.each do |_name, number_data|
          number_data.each do |_type, number|
            assert_predicate TelephoneNumber.parse(number, country).valid_types, :empty?
          end
        end
      end
    end

    def test_valid_types_is_empty_for_blank_input
      inputs = [[nil, nil], [nil, :us], ['3175083385', nil]]
      inputs.each { |number, country| assert TelephoneNumber.invalid?(number, country)}
    end

    # This number is only valid bc of our data override file
    def test_override_file_correctly_validates
      number_obj = TelephoneNumber.parse('248596987', :br)
      assert number_obj.valid?
      assert_includes number_obj.valid_types, :dump_line
    end

    def test_detect_country_for_numbers
      @valid_numbers.each do |country, number_object|
        number_object.each do |_name, number_data|
          assert_equal country, TelephoneNumber::Parser.detect_country(number_data[:e164_formatted])
        end
      end
    end
  end
end
