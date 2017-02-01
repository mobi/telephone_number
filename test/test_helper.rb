$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'yaml'
require 'coveralls'
require 'minitest/autorun'
require 'minitest/focus'
require 'pry'
require 'telephone_number'

Coveralls.wear!
