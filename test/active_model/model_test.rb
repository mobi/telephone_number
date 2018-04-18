require 'test_helper'

class ModelTest < Minitest::Test
  class BasicModel
    include ActiveModel::Validations
    include ActiveModel::Model

    attr_accessor :phone_number

    def country
      :us
    end
  end

  class BasicValidation < BasicModel
    validates :phone_number, telephone_number: { country: proc{ |record| record.country } }
  end

  class CountryValidationWithSymbol < BasicModel
    validates :phone_number, telephone_number: { country: :us }
  end

  class CountryValidationWithString < BasicModel
    validates :phone_number, telephone_number: { country: 'US' }
  end

  class CountryValidationWithArray < BasicModel
    validates :phone_number, telephone_number: { country: [:us] }
  end

  class ValidationWithTypes < BasicModel
    validates :phone_number, telephone_number: { country: proc{ |record| record.country }, types: [:toll_free] }
  end


  class AllowBlankOption < BasicModel
    validates :phone_number, telephone_number: { country: proc{ |record| record.country } }, allow_blank: true
  end

  def test_basic_correctly_validates
    basic_classes = [BasicValidation, CountryValidationWithSymbol, CountryValidationWithString]
    basic_classes.each do |klass|
      assert klass.new(phone_number: '3175082489').valid?
    end

    basic_classes.each do |klass|
      validation1 = klass.new(phone_number: '8')
      assert validation1.invalid?
      assert_includes validation1.errors, :phone_number
    end

    basic_classes.each do |klass|
      validation2 = klass.new(phone_number: nil)
      assert validation2.invalid?
      assert_includes validation2.errors, :phone_number
    end
  end

  def test_with_invalid_option_for_country
    assert_raises ArgumentError do
      CountryValidationWithArray.new('424324543645').valid?
    end
  end

  def test_with_types_correctly_validates
    invalid_obj = ValidationWithTypes.new(phone_number: "3175082489")
    assert invalid_obj.invalid?
    assert_includes invalid_obj.errors, :phone_number

    assert ValidationWithTypes.new(phone_number: "18005559989").valid?
  end

  def test_allow_blank_is_valid
    assert AllowBlankOption.new(phone_number: nil).valid?
    assert AllowBlankOption.new(phone_number: "").valid?
  end
end
