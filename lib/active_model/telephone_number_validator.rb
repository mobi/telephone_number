class TelephoneNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    country_option = options[:country]
    country = if country_option.is_a? Proc
                country_option.call(record)
              elsif country_option.is_a?(Symbol) || country_option.is_a?(String)
                # make sure its a lowercase symbol
                country_option.downcase.to_sym
              end
    valid_types = options.fetch(:types, [])
    args = [value, country, valid_types]
    record.errors.add(attribute, message) if TelephoneNumber.invalid?(*args)
  end

  def message
    options[:message] || :invalid
  end
end
