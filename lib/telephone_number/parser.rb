module TelephoneNumber
  module Parser
    KEYS_TO_SKIP = [TelephoneNumber::PhoneData::GENERAL,
                    TelephoneNumber::PhoneData::AREA_CODE_OPTIONAL]

    def sanitize(input_number)
      return input_number.gsub(/[^0-9]/, "")
    end

    # returns an array of valid types for the normalized number
    # if array is empty, we can assume that the number is invalid
    def validate
      return [] unless country_data
      applicable_keys = country_data[TelephoneNumber::PhoneData::VALIDATIONS].reject{ |key, _value| KEYS_TO_SKIP.include?(key) }
      applicable_keys.map do |phone_type, validations|
        full = "^(#{validations[TelephoneNumber::PhoneData::VALID_PATTERN]})$"
        phone_type if normalized_number =~ Regexp.new(full)
      end.compact
    end

    private

    def build_normalized_number
      return original_number unless country_data
      country_code = country_data[TelephoneNumber::PhoneData::COUNTRY_CODE]

      reg_string  = "^(#{country_code})?"
      reg_string << "(#{country_data[TelephoneNumber::PhoneData::NATIONAL_PREFIX]})?"
      reg_string << "(#{country_data[TelephoneNumber::PhoneData::VALIDATIONS]\
                        [TelephoneNumber::PhoneData::GENERAL]\
                        [TelephoneNumber::PhoneData::VALID_PATTERN]})$"

      match_result = original_number.match(Regexp.new(reg_string))
      return original_number unless match_result
      prefix_results = [match_result[1], match_result[2]]
      original_number.sub(prefix_results.join, "")
    end
  end
end
