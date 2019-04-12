require "test_helper"

class TelephoneNumberTest < Minitest::Test
  def setup
    @valid_numbers = YAML.load_file('test/valid_numbers.yml')
  end

  def test_valid_with_keys_returns_true
    assert TelephoneNumber.valid?("3175082488", "US", [:fixed_line, :mobile, :toll_free])
  end

  def test_valid_with_keys_returns_false
    refute TelephoneNumber.valid?("448444156790", "GB", [:fixed_line, :mobile, :toll_free])
    assert TelephoneNumber.valid?("448444156790", "GB", [:premium_rate])
  end

  def test_valid_with_invalid_country_returns_false
    refute TelephoneNumber.valid?("448444156790", "NOTREAL")
    assert TelephoneNumber.invalid?("448444156790", "NOTREAL")
  end

  def test_valid_types_is_not_empty_when_valid
    @valid_numbers.each do |country, number_object|
      number_object.each do |_name, number_data|
        number_data.each do |_type, number|
          assert TelephoneNumber.valid?(number, country)
          refute TelephoneNumber.invalid?(number, country)
        end
      end
    end
  end

  def test_sanitize_removes_all_non_numeric_characters
    assert_equal "", TelephoneNumber.sanitize("asdfasdfa")
    assert_equal "123", TelephoneNumber.sanitize("abc123")
  end

  def test_valid_formatted_national_number_for_countries
    @valid_numbers.each do |country, number_object|
      number_object.values.each do |number_data|
        number_data.values.each do |number|
          telephone_number = TelephoneNumber.parse(number, country)
          assert_equal number_data[:national_formatted], telephone_number.national_number, "number was #{number}"
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

  # Our data override file ensures that this number is valid but doesn't provide a formatting rule
  # which means the national and international number methods should just return the normalized number
  def test_override_file_correctly_formats
    number_obj = TelephoneNumber.parse('81', :br)
    assert_equal '81', number_obj.national_number
    assert_equal '81', number_obj.international_number
    assert_equal '+5581', number_obj.e164_number
  end

  def test_returns_empty_string_if_input_is_nil
    country_inputs = [nil, '', :us]
    number_inputs = [nil, '']
    methods = [:international_number, :national_number, :e164_number]

    country_inputs.product(number_inputs, methods).each do |country, number, method|
      assert_equal '', TelephoneNumber.parse(number, country).public_send(method)
    end
  end

  def test_invalid_numbers_go_to_default_pattern
    TelephoneNumber.default_format_pattern = "(\\d{3})(\\d{3})(\\d*)"
    TelephoneNumber.default_format_string = "($1) $2-$3"
    invalid_number = "1111111111"
    assert_equal "(111) 111-1111", TelephoneNumber.parse(invalid_number, :us).national_number

    TelephoneNumber.instance_variable_set(:@default_format_pattern, nil)
    TelephoneNumber.instance_variable_set(:@default_format_string, nil)
  end
end
