require 'coveralls'
require 'simplecov'


# SimpleCov.start 'test_frameworks'
SimpleCov.start do
  add_filter "/test/"
end

Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'yaml'
require 'minitest/autorun'
require 'minitest/focus'
require 'pry'
require 'telephone_number'

TelephoneNumber.override_file = 'test/telephone_number_data_override_file.dat'

