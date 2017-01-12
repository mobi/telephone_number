module TelephoneNumber
  module Parser
    KEYS_TO_SKIP = [TelephoneNumber::PhoneData::GENERAL,
                    TelephoneNumber::PhoneData::AREA_CODE_OPTIONAL]

    def sanitize(input_number)
      return input_number.gsub(/[^0-9]/, "")
    end

    def extract_number_types(input_number, country)
      country_data = TelephoneNumber::PhoneData.phone_data[country.to_sym]

      return [input_number, nil] unless country_data
      country_code = country_data[TelephoneNumber::PhoneData::COUNTRY_CODE]

      reg_string  = "^(#{country_code})?"
      reg_string += "(#{country_data[TelephoneNumber::PhoneData::NATIONAL_PREFIX]})?"
      reg_string += "(#{country_data[TelephoneNumber::PhoneData::VALIDATIONS]\
                        [TelephoneNumber::PhoneData::GENERAL]\
                        [TelephoneNumber::PhoneData::VALID_PATTERN]})$"

      match_result = input_number.match(Regexp.new(reg_string)) || []

      prefix_results = [match_result[1], match_result[2]]
      without_prefix = input_number.sub(prefix_results.join, "")
      [without_prefix, "#{country_code}#{without_prefix}"]
    end

    def validate(normalized_number, country)
      country_data = TelephoneNumber::PhoneData.phone_data[country.to_sym]
      return [] unless country_data
      applicable_keys = country_data[TelephoneNumber::PhoneData::VALIDATIONS].reject{ |key, _value| KEYS_TO_SKIP.include?(key) }
      applicable_keys.map do |phone_type, validations|
        full = "^(#{country_data[TelephoneNumber::PhoneData::COUNTRY_CODE]})(#{validations[TelephoneNumber::PhoneData::VALID_PATTERN]})$"
        phone_type if normalized_number =~ Regexp.new(full)
      end.compact
    end
  end
end
