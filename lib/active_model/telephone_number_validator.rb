class TelephoneNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    valid_types = options.fetch(:types, [])
    args = [value, country(record), valid_types]
    record.errors.add(attribute, message(record)) if TelephoneNumber.invalid?(*args)
  end

  def message(record)
    message_option = options[:message]
    if message_option.is_a? Proc
      message_option.call(record)
    else
      options[:message] || :invalid
    end
  end

  def country(record)
    country_option = options[:country]
    if country_option.is_a? Proc
      country_option.call(record)
    elsif country_option.is_a?(Symbol) || country_option.is_a?(String)
      # make sure its a lowercase symbol
      country_option.downcase.to_sym
    else
      raise ArgumentError.new('country option must be a Proc, Symbol or String')
    end
  end
end
