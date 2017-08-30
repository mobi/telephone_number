require "test_helper"
require "ostruct"

module TelephoneNumber
  class ParserTest < Minitest::Test
    def setup
      @valid_numbers = YAML.load_file('test/valid_numbers.yml')
      @invalid_numbers = YAML.load_file('test/invalid_numbers.yml')
    end

    def test_valid_types_is_not_empty_when_valid
      @valid_numbers.each do |country, number_object|
        country_obj = Country.find(country)
        number_object.each do |_name, number_data|
          number_data.each do |_type, number|
            phone_obj = OpenStruct.new(original_number: number.gsub(/\D/, ''), country: country_obj)
            parser = TelephoneNumber::Parser.new(phone_obj)
            refute_predicate parser.valid_types, :empty?
            assert parser.valid?
          end
        end
      end
    end

    def test_valid_types_returns_correct_list
      phone_obj = OpenStruct.new(original_number: "3175082203", country: Country.find(:us))
      assert_equal [:fixed_line, :mobile], TelephoneNumber::Parser.new(phone_obj).valid_types
    end

    def test_valid_types_is_empty_for_blank_input
      [["", nil], ["", :us], ['3175083385', nil]].each do |number, country|
        phone_obj = OpenStruct.new(original_number: number, country: Country.find(country))
        parser = TelephoneNumber::Parser.new(phone_obj)
        refute parser.valid?
        assert_predicate parser.valid_types, :empty?
      end
    end

    # This number is only valid bc of our data override file
    def test_override_file_correctly_validates
      phone_obj = OpenStruct.new(original_number: '81', country: Country.find(:br))
      parser = TelephoneNumber::Parser.new(phone_obj)
      assert parser.valid?
      assert_includes parser.valid_types, :dump_line
    end
  end
end
