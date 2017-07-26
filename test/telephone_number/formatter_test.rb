require 'test_helper'
require 'ostruct'

module TelephoneNumber
  class FormatterTest < Minitest::Test
    def setup
      @valid_phone_obj = OpenStruct.new(country: Country.find(:us),
                                        valid?: true,
                                        normalized_number: "3175082203",
                                        original_number: "13175082203")

      @invalid_phone_obj = OpenStruct.new(country: Country.find(:us),
                                          valid?: false,
                                          normalized_number: "3175082203",
                                          original_number: "13175082203")
    end

    def test_national_number_if_valid
      formatter = TelephoneNumber::Formatter.new(@valid_phone_obj)
      assert_equal "(317) 508-2203", formatter.national_number
      assert_equal "3175082203", formatter.national_number(formatted: false)
    end

    def test_national_number_if_invalid
      formatter = TelephoneNumber::Formatter.new(@invalid_phone_obj)
      assert_equal "13175082203", formatter.national_number
      assert_equal "13175082203", formatter.national_number(formatted: false)
    end

    def test_international_number_if_valid
      formatter = TelephoneNumber::Formatter.new(@valid_phone_obj)
      assert_equal "+1 317-508-2203", formatter.international_number
      assert_equal "13175082203", formatter.international_number(formatted: false)
    end

    def test_international_number_if_invalid
      formatter = TelephoneNumber::Formatter.new(@invalid_phone_obj)
      assert_equal "13175082203", formatter.international_number
      assert_equal "13175082203", formatter.international_number(formatted: false)
    end

    def test_e164_number_if_valid
      formatter = TelephoneNumber::Formatter.new(@valid_phone_obj)
      assert_equal "+13175082203", formatter.e164_number
      assert_equal "13175082203", formatter.e164_number(formatted: false)
    end

    def test_e164_number_if_invalid
      phone_obj = OpenStruct.new(country: Country.find(:us),
                                 valid?: false,
                                 normalized_number: "3175082203",
                                 original_number: "3175082203")

      formatter = TelephoneNumber::Formatter.new(phone_obj)
      assert_equal "3175082203", formatter.e164_number
      assert_equal "3175082203", formatter.e164_number(formatted: false)
    end
  end
end
