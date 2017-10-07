require 'telephone_number/version'
require 'utilities/hash'
require 'active_model/telephone_number_validator' if defined?(ActiveModel)

module TelephoneNumber
  autoload :ClassMethods,            'telephone_number/class_methods'
  autoload :Country,                 'telephone_number/country'
  autoload :Formatter,               'telephone_number/formatter'
  autoload :GeoLocator,              'telephone_number/geo_locator'
  autoload :Number,                  'telephone_number/number'
  autoload :NumberFormat,            'telephone_number/number_format'
  autoload :NumberValidation,        'telephone_number/number_validation'
  autoload :Parser,                  'telephone_number/parser'
  autoload :GeoLocationDataImporter, 'importers/geo_location_data_importer'
  autoload :PhoneDataImporter,       'importers/phone_data_importer'
  autoload :TestDataImporter,        'importers/test_data_importer'

  extend ClassMethods
end
