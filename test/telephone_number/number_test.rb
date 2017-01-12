require "test_helper"

module TelephoneNumber
  class NumberTest < Minitest::Test
    def test_valid_with_keys_returns_true
      assert TelephoneNumber.valid?("3175082489", :US, [:fixed_line, :mobile, :toll_free])
    end

    def test_valid_with_keys_returns_false
      refute TelephoneNumber.valid?("448444156790", :GB, [:fixed_line, :mobile, :toll_free])
      assert TelephoneNumber.valid?("448444156790", :GB, [:shared_cost])
    end
  end
end
