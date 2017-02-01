module TelephoneNumber
  module Formatter
    def build_national_number(formatted: true)
      return normalized_number if !valid? || format.nil?
      captures = normalized_number.match(Regexp.new(format[TelephoneNumber::PhoneData::PATTERN])).captures
      national_prefix_formatting_rule = format[TelephoneNumber::PhoneData::NATIONAL_PREFIX_FORMATTING_RULE] \
                                         || country_data[TelephoneNumber::PhoneData::NATIONAL_PREFIX_FORMATTING_RULE]

      format_string = format[:format].gsub(/(\$\d)/) {|cap| "%#{cap.reverse}s"}
      formatted_string = sprintf(format_string, *captures)
      captures.delete(TelephoneNumber::PhoneData::MOBILE_TOKEN_COUNTRIES[country])

      if national_prefix_formatting_rule
        national_prefix_string = national_prefix_formatting_rule.dup
        national_prefix_string.gsub!(/\$NP/, country_data[TelephoneNumber::PhoneData::NATIONAL_PREFIX])
        national_prefix_string.gsub!(/\$FG/, captures[0])
        formatted_string.sub!(captures[0], national_prefix_string)
      end

      formatted ? formatted_string : sanitize(formatted_string)
    end

    private

    def extract_format
      native_country_format = detect_format(country.to_sym)
      return native_country_format if native_country_format

      # This means we couldn't find an applicable format so we now need to scan through the hierarchy
      parent_country_code = TelephoneNumber::PhoneData.phone_data.detect do |country_code, country_data|
        country_data[TelephoneNumber::PhoneData::COUNTRY_CODE] == TelephoneNumber::PhoneData.phone_data[self.country.to_sym][TelephoneNumber::PhoneData::COUNTRY_CODE] \
          && country_data[TelephoneNumber::PhoneData::MAIN_COUNTRY_FOR_CODE] == 'true'
      end
      detect_format(parent_country_code[0])
    end

    def detect_format(country_code)
      data_for_country = TelephoneNumber::PhoneData.phone_data[country_code.to_sym]
      data_for_country[TelephoneNumber::PhoneData::FORMATS].detect do |format|
        (format[TelephoneNumber::PhoneData::LEADING_DIGITS].nil? \
          || normalized_number =~ Regexp.new("^(#{format[TelephoneNumber::PhoneData::LEADING_DIGITS]})")) \
          && normalized_number =~ Regexp.new("^(#{format[TelephoneNumber::PhoneData::PATTERN]})$")
      end
    end
  end
end


