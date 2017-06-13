module TelephoneNumber
  class Formatter
    extend Forwardable

    attr_reader :normalized_number, :phone_data, :valid

    delegate [:country_data, :country] => :phone_data

    def initialize(number_obj, phone_data)
      @normalized_number = number_obj.normalized_number
      @phone_data = phone_data
      @valid = number_obj.valid?
    end

    def national_number(formatted: true)
      if formatted
        @formatted_national_number ||= build_national_number
      else
        @national_number ||= build_national_number(formatted: false)
      end
    end

    def e164_number(formatted: true)
      if formatted
        @formatted_e164_number ||= build_e164_number
      else
        @e164_number ||= build_e164_number(formatted: false)
      end
    end

    def international_number(formatted: true)
      if formatted
        @formatted_international_number ||= build_international_number
      else
        @international_number ||= build_international_number(formatted: false)
      end
    end

    alias_method :valid?, :valid

    private

    def number_format
      @number_format ||= extract_number_format
    end

    def build_national_number(formatted: true)
      return normalized_or_default if !valid? || number_format.nil?
      captures = normalized_number.match(Regexp.new(number_format[PhoneData::PATTERN])).captures
      national_prefix_formatting_rule = number_format[PhoneData::NATIONAL_PREFIX_FORMATTING_RULE] \
                                         || country_data[PhoneData::NATIONAL_PREFIX_FORMATTING_RULE]

      formatted_string = format(ruby_format_string(number_format[PhoneData::FORMAT]), *captures)
      captures.delete(PhoneData::MOBILE_TOKEN_COUNTRIES[country])

      if national_prefix_formatting_rule
        national_prefix_string = national_prefix_formatting_rule.dup
        national_prefix_string.gsub!(/\$NP/, country_data[PhoneData::NATIONAL_PREFIX])
        national_prefix_string.gsub!(/\$FG/, captures[0])
        formatted_string.sub!(captures[0], national_prefix_string)
      end

      formatted ? formatted_string : Parser.sanitize(formatted_string)
    end

    def build_e164_number(formatted: true)
      return normalized_or_default if !country_data || normalized_number.empty?
      formatted_string = "+#{country_data[PhoneData::COUNTRY_CODE]}#{normalized_number}"
      formatted ? formatted_string : Parser.sanitize(formatted_string)
    end

    def build_international_number(formatted: true)
      return normalized_or_default if !valid? || number_format.nil?
      captures = normalized_number.match(Regexp.new(number_format[PhoneData::PATTERN])).captures
      key = number_format.fetch(PhoneData::INTL_FORMAT, 'NA') != 'NA' ? PhoneData::INTL_FORMAT : PhoneData::FORMAT
      formatted_string = "+#{country_data[PhoneData::COUNTRY_CODE]} #{format(ruby_format_string(number_format[key]), *captures)}"
      formatted ? formatted_string : Parser.sanitize(formatted_string)
    end

    def ruby_format_string(format_string)
      format_string.gsub(/(\$\d)/) { |cap| "%#{cap.reverse}s" }
    end

    def normalized_or_default
      return normalized_number unless TelephoneNumber.default_format_string && TelephoneNumber.default_format_pattern
      captures = normalized_number.match(TelephoneNumber.default_format_pattern).captures
      format(ruby_format_string(TelephoneNumber.default_format_string), *captures)
    end

    def extract_number_format
      native_country_format = detect_format(country.to_sym)
      return native_country_format if native_country_format

      # This means we couldn't find an applicable format so we now need to scan through the hierarchy
      parent_country_code = PhoneData.phone_data.detect do |_country_code, country_data|
        country_data[PhoneData::COUNTRY_CODE] == PhoneData.phone_data[self.country.to_sym][PhoneData::COUNTRY_CODE] \
          && country_data[PhoneData::MAIN_COUNTRY_FOR_CODE] == 'true'
      end

      detect_format(parent_country_code[0]) if parent_country_code
    end

    def detect_format(country_code)
      PhoneData.phone_data[country_code.to_sym][PhoneData::FORMATS].detect do |format|
        (format[PhoneData::LEADING_DIGITS].nil? \
          || normalized_number =~ Regexp.new("^(#{format[PhoneData::LEADING_DIGITS]})")) \
          && normalized_number =~ Regexp.new("^(#{format[PhoneData::PATTERN]})$")
      end
    end
  end
end


