require "test_helper"

module TelephoneNumber
  class PhoneDataImporterTest < Minitest::Test
    def teardown
      FileUtils.rm_rf('telephone_number_data_override_file.dat', secure: true)
    end

    def test_empty_values_are_removed_on_override_import
      TelephoneNumber.generate_override_file('test/telephone_number/files/telephone_number_data_file_override.xml')
      data_file = "#{File.dirname(__FILE__)}/../../telephone_number_data_override_file.dat"
      main_data = Marshal.load(File.binread(data_file))
      assert_nil main_data[:US][:formats]
    end
  end
end
