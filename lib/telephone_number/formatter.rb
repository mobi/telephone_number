module TelephoneNumber
  module Formatter
    def build_national_number(formatted: true)
      return normalized_or_default if !valid? || format.nil?
      captures = normalized_number.match(Regexp.new(format[PhoneData::PATTERN])).captures
      national_prefix_formatting_rule = format[PhoneData::NATIONAL_PREFIX_FORMATTING_RULE] \
                                         || country_data[PhoneData::NATIONAL_PREFIX_FORMATTING_RULE]

      format_string = format[PhoneData::FORMAT].gsub(/(\$\d)/) { |cap| "%#{cap.reverse}s" }
      formatted_string = sprintf(format_string, *captures)
      captures.delete(PhoneData::MOBILE_TOKEN_COUNTRIES[country])

      if national_prefix_formatting_rule
        national_prefix_string = national_prefix_formatting_rule.dup
        national_prefix_string.gsub!(/\$NP/, country_data[PhoneData::NATIONAL_PREFIX])
        national_prefix_string.gsub!(/\$FG/, captures[0])
        formatted_string.sub!(captures[0], national_prefix_string)
      end

      formatted ? formatted_string : sanitize(formatted_string)
    end

    def build_e164_number(formatted: true)
      formatted_string = "+#{country_data[PhoneData::COUNTRY_CODE]}#{normalized_number}"
      formatted ? formatted_string : sanitize(formatted_string)
    end

    def build_international_number(formatted: true)
      return normalized_or_default if !valid? || format.nil?
      captures = normalized_number.match(Regexp.new(format[PhoneData::PATTERN])).captures
      key = format.fetch(PhoneData::INTL_FORMAT, 'NA') != 'NA' ? PhoneData::INTL_FORMAT : PhoneData::FORMAT
      format_string = format[key].gsub(/(\$\d)/) { |cap| "%#{cap.reverse}s" }
      "+#{country_data[PhoneData::COUNTRY_CODE]} #{sprintf(format_string, *captures)}"
    end

    private

    def normalized_or_default
      return normalized_number if !TelephoneNumber.default_format_string || !TelephoneNumber.default_format_pattern
      captures = normalized_number.match(TelephoneNumber.default_format_pattern).captures
      format_string = TelephoneNumber.default_format_string.gsub(/(\$\d)/) { |cap| "%#{cap.reverse}s" }
      sprintf(format_string, *captures)
    end

    def extract_format
      native_country_format = detect_format(country.to_sym)
      return native_country_format if native_country_format

      # This means we couldn't find an applicable format so we now need to scan through the hierarchy
      parent_country_code = PhoneData.phone_data.detect do |country_code, country_data|
        country_data[PhoneData::COUNTRY_CODE] == PhoneData.phone_data[self.country.to_sym][PhoneData::COUNTRY_CODE] \
          && country_data[PhoneData::MAIN_COUNTRY_FOR_CODE] == 'true'
      end
      detect_format(parent_country_code[0])
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


