require "telephone_number/version"

module TelephoneNumber
  autoload :DataImporter, 'telephone_number/data_importer'
  autoload :Parser, 'telephone_number/parser'
  autoload :Number, 'telephone_number/number'
  autoload :PhoneData, 'telephone_number/phone_data'
  autoload :ClassMethods, 'telephone_number/class_methods'

  extend ClassMethods

  # allows users to override the default data
  @@override_file = nil

  def self.override_file=(file_name)
    @@override_file = file_name
  end

  def self.override_file
    @@override_file
  end

  # generates binary file from xml that user gives us
  def self.generate_override_file(file)
    DataImporter.new(file).import!(override: true)
  end

end
