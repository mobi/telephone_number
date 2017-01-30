module TelephoneNumber
  module Parser
    KEYS_TO_SKIP = [PhoneData::GENERAL, PhoneData::AREA_CODE_OPTIONAL]

    def sanitize(input_number)
      return input_number.gsub(/[^0-9]/, "")
    end

    # returns an array of valid types for the normalized number
    # if array is empty, we can assume that the number is invalid
    def validate
      return [] unless country_data
      applicable_keys = country_data[PhoneData::VALIDATIONS].reject{ |key, _value| KEYS_TO_SKIP.include?(key) }
      applicable_keys.map do |phone_type, validations|
        full = "^(#{validations[PhoneData::VALID_PATTERN]})$"
        phone_type.to_sym if normalized_number =~ Regexp.new(full)
      end.compact
    end

    private

    def build_normalized_number
      return original_number unless country_data
      country_code = country_data[PhoneData::COUNTRY_CODE]

      number_with_correct_prefix = parse_prefix

      reg_string  = "^(#{country_code})?"
      reg_string << "(#{country_data[PhoneData::NATIONAL_PREFIX]})?"
      reg_string << "(#{country_data[PhoneData::VALIDATIONS][PhoneData::GENERAL][PhoneData::VALID_PATTERN]})$"

      match_result = number_with_correct_prefix.match(Regexp.new(reg_string))
      return original_number unless match_result
      prefix_results = [match_result[1], match_result[2]]
      number_with_correct_prefix.sub(prefix_results.join, '')
    end

    def parse_prefix
      return original_number unless country_data[:national_prefix_for_parsing]
      duped = original_number.dup
      match_object = duped.match(Regexp.new(country_data[:national_prefix_for_parsing]))

      # we need to do the "start_with?" here because we need to make sure it's not finding
      # something in the middle of the number. However, we can't modify the regex to do this
      # for us because it will offset the match groups that are referenced in the transform rules
      return original_number unless match_object && duped.start_with?(match_object[0])
      if country_data[:national_prefix_transform_rule]
        transform_national_prefix(duped, match_object)
      else
        duped.sub!(match_object[0], '')
      end
    end

    def transform_national_prefix(duped, match_object)
      if PhoneData::MOBILE_TOKEN_COUNTRIES.include?(country) && match_object.captures.any?
        sprintf(build_format_string, duped.sub!(match_object[0], match_object[1]))
      elsif match_object.captures.none?
        duped.sub!(match_object[0], '')
      else
        sprintf(build_format_string, *match_object.captures)
      end
    end

    def build_format_string
      country_data[:national_prefix_transform_rule].gsub(/(\$\d)/) {|cap| "%#{cap.reverse}s"}
    end
  end
end
