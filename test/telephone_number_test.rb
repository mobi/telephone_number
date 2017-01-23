require "test_helper"

class TelephoneNumberTest < Minitest::Test
  def test_valid_with_keys_returns_true
    assert TelephoneNumber.valid?("3175082489", "US", [:fixed_line, :mobile, :toll_free])
  end

  def test_valid_with_keys_returns_false
    refute TelephoneNumber.valid?("448444156790", "GB", [:fixed_line, :mobile, :toll_free])
    assert TelephoneNumber.valid?("448444156790", "GB", [:shared_cost])
  end

  def test_valid_without_keys_returns_true
    assert TelephoneNumber.valid?("3175082489", "US")
    assert TelephoneNumber.valid?("448444156790", "GB")
  end

  def test_valid_with_invalid_country_returns_false
    refute TelephoneNumber.valid?("448444156790", "NOTREAL")
  end

  def test_invalid_returns_false_if_valid
    assert TelephoneNumber.valid?('6502530000', 'US')
    refute TelephoneNumber.invalid?('6502530000', 'US')
  end

  def test_invalid_returns_true_if_not_valid
    refute TelephoneNumber.valid?('6502530000', 'INVALID')
    assert TelephoneNumber.invalid?('6502530000', 'INVALID')
  end
end

