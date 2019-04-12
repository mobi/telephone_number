require "test_helper"

module TelephoneNumber
  class GeoLocatorTest < Minitest::Test
    def test_defaults_to_us_if_invalid_locale
      assert_equal 'Indiana', TelephoneNumber.parse('3175082203', :us).location(:xxx)
    end

    def test_returns_nil_if_number_is_invalid
      assert_nil TelephoneNumber.parse('192938347739293838', :us).location
    end

    def test_returns_correct_area
      assert_equal 'Carmel, IN', TelephoneNumber.parse('13175827767').location # US
      assert_equal 'Buenos Aires', TelephoneNumber.parse('+541148910000').location # Argentina
      assert_equal 'Neuquén, Neuquén', TelephoneNumber.parse('+5492994104587').location # Argentina, no mobile_token
      assert_equal 'São Paulo', TelephoneNumber.parse('+5511992339376').location # Brazil
      assert_equal 'Grodno', TelephoneNumber.parse('+375152450911').location # Belarus
      assert_equal 'Ontario', TelephoneNumber.parse('+16135550122').location # Canada
      assert_equal 'Shijiazhuang, Hebei', TelephoneNumber.parse('+8615694876068').location # China
      assert_equal 'Bogotá', TelephoneNumber.parse('+5712345678').location # Colombia
      assert_equal 'London', TelephoneNumber.parse('+442076361000').location # UK
      assert_equal 'Agra, Uttar Pradesh', TelephoneNumber.parse('+915622231515').location # India
      assert_equal 'Tokyo', TelephoneNumber.parse('+81312345678').location # Japan
      assert_equal 'Queretaro', TelephoneNumber.parse('+524423593227').location # Mexico
    end

    def test_returns_correct_locale
      # Argentina, no mobile_token
      assert_equal 'Buenos Aires', TelephoneNumber.parse('+541148910000').location(:es)
      assert_equal '大阪', TelephoneNumber.parse('81666286111').location(:ja)
    end
  end
end
