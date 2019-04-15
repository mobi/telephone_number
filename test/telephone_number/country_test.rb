require "test_helper"

module TelephoneNumber
  class CountryTest < Minitest::Test
    def test_initialize_sets_correct_attributes
      country = Country.new(init_attrs)
      assert_equal "1", country.country_code
      assert_equal "US", country.country_id
      assert_equal "1", country.national_prefix
      assert_equal /011/, country.international_prefix
      assert_equal 2, country.formats.count
      assert_equal 5, country.validations.count
      assert_nil country.national_prefix_for_parsing
      assert_nil country.national_prefix_transform_rule
      assert_nil country.mobile_token
      assert country.main_country_for_code
      assert country.general_validation.is_a?(NumberValidation)
    end

    def test_parent_country_correctly_finds_parent_country
      canada = Country.new(country_code: "1", id: "CA")
      assert_equal 'US', canada.parent_country.country_id

      us = Country.new(country_code: "1", id: "US", main_country_for_code: "true")
      assert_nil us.parent_country
    end

    def test_find_correctly_finds
      assert_nil Country.find("BOGUS")
      assert_equal 'US', Country.find("US").country_id
      assert_equal 'US', Country.find("us").country_id
      assert_equal 'US', Country.find(:us).country_id
      assert_equal 'US', Country.find(:US).country_id
    end

    def test_detect_format_correctly_finds_native_format
      us = Country.find(:us)
      assert_equal /(\d{3})(\d{3})(\d{4})/, us.detect_format("3175082203").pattern
    end

    def test_detect_format_correctly_finds_parent_format
      ca = Country.find(:ca)
      assert_equal /(\d{3})(\d{3})(\d{4})/, ca.detect_format("6135550119").pattern
    end

    private

    def init_attrs
      {:id=>"US",
       :country_code=>"1",
       :international_prefix=>"011",
       :main_country_for_code=>"true",
       :national_prefix=>"1",
       :national_prefix_optional_when_formatting=>"true",
       :mobile_number_portable_region=>"true",
       :references=>["http://www.nanpa.com/reports/reports_npa.html", "http://en.wikipedia.org/wiki/North_American_Numbering_Plan"],
       :validations=>
        {:general_desc=>{:national_number_pattern=>"[2-9]\\d{9}"},
         :fixed_line=>
          {:national_number_pattern=>
            "(?:2(?:0[1-35-9]|1[02-9]|2[04589]|3[149]|4[08]|5[1-46]|6[0279]|7[026]|8[13])|3(?:0[1-57-9]|1[02-9]|2[0135]|3[014679]|4[67]|5[12]|6[014]|8[056])|4(?:0[124-9]|1[02-579]|2[3-5]|3[0245]|4[0235]|58|6[39]|7[0589]|8[04])|5(?:0[1-57-9]|1[0235-8]|20|3[0149]|4[01]|5[19]|6[1-37]|7[013-5]|8[056])|6(?:0[1-35-9]|1[024-9]|2[03689]|3[016]|4[16]|5[017]|6[0-279]|78|8[012])|7(?:0[1-46-8]|1[02-9]|2[0457]|3[1247]|4[037]|5[47]|6[02359]|7[02-59]|8[156])|8(?:0[1-68]|1[02-8]|28|3[0-25]|4[3578]|5[046-9]|6[02-5]|7[028])|9(?:0[1346-9]|1[02-9]|2[0589]|3[014678]|4[0179]|5[12469]|7[0-3589]|8[0459]))[2-9]\\d{6}",
           :possible_lengths=>"",
           :example_number=>"2015550123"},
         :mobile=>
          {:national_number_pattern=>
            "(?:2(?:0[1-35-9]|1[02-9]|2[04589]|3[149]|4[08]|5[1-46]|6[0279]|7[026]|8[13])|3(?:0[1-57-9]|1[02-9]|2[0135]|3[014679]|4[67]|5[12]|6[014]|8[056])|4(?:0[124-9]|1[02-579]|2[3-5]|3[0245]|4[0235]|58|6[39]|7[0589]|8[04])|5(?:0[1-57-9]|1[0235-8]|20|3[0149]|4[01]|5[19]|6[1-37]|7[013-5]|8[056])|6(?:0[1-35-9]|1[024-9]|2[03689]|3[016]|4[16]|5[017]|6[0-279]|78|8[012])|7(?:0[1-46-8]|1[02-9]|2[0457]|3[1247]|4[037]|5[47]|6[02359]|7[02-59]|8[156])|8(?:0[1-68]|1[02-8]|28|3[0-25]|4[3578]|5[046-9]|6[02-5]|7[028])|9(?:0[1346-9]|1[02-9]|2[0589]|3[014678]|4[0179]|5[12469]|7[0-3589]|8[0459]))[2-9]\\d{6}",
           :possible_lengths=>"",
           :example_number=>"2015550123"},
         :toll_free=>
          {:national_number_pattern=>"8(?:00|33|44|55|66|77|88)[2-9]\\d{6}", :possible_lengths=>"", :example_number=>"8002345678"},
         :premium_rate=>{:national_number_pattern=>"900[2-9]\\d{6}", :possible_lengths=>"", :example_number=>"9002345678"},
         :personal_number=>
          {:national_number_pattern=>"5(?:00|22|33|44|66|77|88)[2-9]\\d{6}", :possible_lengths=>"", :example_number=>"5002345678"}},
       :formats=>
        [{:pattern=>"(\\d{3})(\\d{4})", :format=>"$1-$2", :intl_format=>"NA"},
         {:pattern=>"(\\d{3})(\\d{3})(\\d{4})", :format=>"($1) $2-$3", :intl_format=>"$1-$2-$3"}]}
    end
  end
end
