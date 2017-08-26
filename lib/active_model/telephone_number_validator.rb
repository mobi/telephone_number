class TelephoneNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    country = options[:country].call(record) if options.key?(:country)
    valid_types = options.fetch(:types, [])
    args = [value, country, valid_types]

    record.errors.add(attribute, :invalid) if TelephoneNumber.invalid?(*args)
  end
end
