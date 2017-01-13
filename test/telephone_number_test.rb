require 'test_helper'

class TelephoneNumberTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TelephoneNumber::VERSION
  end
end
