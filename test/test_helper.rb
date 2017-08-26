require 'coveralls'
require 'simplecov'

# SimpleCov.start 'test_frameworks'
SimpleCov.start do
  add_filter "/test/"
end

Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'active_model'
require 'minitest/autorun'
require 'minitest/focus'
require 'pry'
require 'yaml'
require 'telephone_number'

TelephoneNumber.override_file = 'test/telephone_number_data_override_file.dat'

