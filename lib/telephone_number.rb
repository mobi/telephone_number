require 'telephone_number/version'
require 'utilities/hash'
require 'active_model/telephone_number_validator' if defined?(ActiveModel)

module TelephoneNumber
  autoload :DataImporter,      'telephone_number/data_importer'
  autoload :TestDataGenerator, 'telephone_number/test_data_generator'
  autoload :Parser,            'telephone_number/parser'
  autoload :Number,            'telephone_number/number'
  autoload :Formatter,         'telephone_number/formatter'
  autoload :Country,           'telephone_number/country'
  autoload :NumberFormat,      'telephone_number/number_format'
  autoload :NumberValidation,  'telephone_number/number_validation'
  autoload :ClassMethods,      'telephone_number/class_methods'

  extend ClassMethods
end
