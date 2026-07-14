require 'coveralls'
require 'simplecov'

Coveralls.wear! do
  add_filter "/test/"
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'active_model'
require 'minitest/autorun'
require 'minitest/focus'
require 'pry'
require 'yaml'
require 'telephone_number'

TelephoneNumber.override_file = 'test/telephone_number_data_override_file.dat'

