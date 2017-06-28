module TelephoneNumber
  class Parser
    KEYS_TO_SKIP = [PhoneData::GENERAL, PhoneData::AREA_CODE_OPTIONAL]
    extend Forwardable

    delegate [:country_data, :country] => :phone_data
    attr_reader :sanitized_number, :original_number, :normalized_number, :phone_data

    def initialize(original_number, phone_data)
      @sanitized_number = self.class.sanitize(original_number)
      @phone_data = phone_data
      @original_number = original_number
      @normalized_number = build_normalized_number
    end

    def valid_types
      @valid_types ||= validate
    end

    def valid?(keys = [])
      keys.empty? ? !valid_types.empty? : !(valid_types & keys.map(&:to_sym)).empty?
    end

    def self.detect_country(number)
      sanitized_number = sanitize(number)
      detected_country = PhoneData.phone_data.detect(->{[]}) do |two_letter, value|
        sanitized_number =~ Regexp.new("^#{value[:country_code]}") && new(sanitized_number, PhoneData.new(two_letter)).valid?
      end.first
    end

    def self.sanitize(input_number)
      return input_number.to_s.gsub(/\D/, '')
    end

    private

    # returns an array of valid types for the normalized number
    # if array is empty, we can assume that the number is invalid
    def validate
      return [] unless country_data
      applicable_keys = country_data[PhoneData::VALIDATIONS].reject { |key, _value| KEYS_TO_SKIP.include?(key) }
      applicable_keys.map do |phone_type, validations|
        full = "^(#{validations[PhoneData::VALID_PATTERN]})$"
        phone_type.to_sym if normalized_number =~ Regexp.new(full)
      end.compact
    end

    # normalized_number is basically a "best effort" at national number without
    # any formatting. This is what we will use to derive formats, validations and
    # basically anything else that uses google data
    def build_normalized_number
      return sanitized_number unless country_data

      number_with_correct_prefix = parse_prefix

      reg_string = "^(#{country_data[PhoneData::COUNTRY_CODE]})?"
      reg_string << "(#{country_data[PhoneData::NATIONAL_PREFIX]})?"
      reg_string << "(#{country_data[PhoneData::VALIDATIONS][PhoneData::GENERAL][PhoneData::VALID_PATTERN]})$"

      match_result = number_with_correct_prefix.match(Regexp.new(reg_string))
      return sanitized_number unless match_result
      prefix_results = [match_result[1], match_result[2]]
      number_with_correct_prefix.sub(prefix_results.join, '')
    end

    def parse_prefix
      return sanitized_number unless country_data[:national_prefix_for_parsing]
      duped = sanitized_number.dup
      match_object = duped.match(Regexp.new(country_data[:national_prefix_for_parsing]))

      # we need to do the "start_with?" here because we need to make sure it's not finding
      # something in the middle of the number. However, we can't modify the regex to do this
      # for us because it will offset the match groups that are referenced in the transform rules
      return sanitized_number unless match_object && duped.start_with?(match_object[0])
      if country_data[:national_prefix_transform_rule]
        transform_national_prefix(duped, match_object)
      else
        duped.sub!(match_object[0], '')
      end
    end

    def transform_national_prefix(duped, match_object)
      if PhoneData::MOBILE_TOKEN_COUNTRIES.include?(country) && match_object.captures.any?
        format(build_format_string, duped.sub!(match_object[0], match_object[1]))
      elsif match_object.captures.none?
        duped.sub!(match_object[0], '')
      else
        format(build_format_string, *match_object.captures)
      end
    end

    def build_format_string
      country_data[:national_prefix_transform_rule].gsub(/(\$\d)/) { |cap| "%#{cap.reverse}s" }
    end
  end
end
