module TelephoneNumber
  require 'nokogiri'
  class DataImporter
    attr_reader :data, :file

    def initialize(file_name)
      @data = {}
      @file = File.open(file_name){ |f| Nokogiri::XML(f) }
    end

    def import!(override: false)
      parse_main_data
      save_data_file(override: override)
    end

    def parse_main_data
      file.css("territories territory").each do |territory|
        country_code = territory.attributes["id"].value.to_sym
        @data[country_code] ||= {}

        load_base_attributes(@data[country_code], territory)
        load_references(@data[country_code], territory)
        load_validations(@data[country_code], territory)
        load_formats(@data[country_code], territory)
      end
    end

    private

    def load_formats(country_data, territory)
      country_data[TelephoneNumber::PhoneData::FORMATS] = territory.css("availableFormats numberFormat").map do |format|
        format_hash = {}.tap do |fhash|
          format.attributes.values.each { |attr| fhash[attr.name.to_sym] = attr.value.delete("\n ") }
          format.elements.each { |child| fhash[child.name.to_sym] = child.text.delete("\n ") }
        end
      end
    end

    def load_validations(country_data, territory)
      country_data[TelephoneNumber::PhoneData::VALIDATIONS] = {}
      territory.elements.each do |element|
        next if element.name == "references" || element.name == "availableFormats"
        country_data[TelephoneNumber::PhoneData::VALIDATIONS][underscore(element.name).to_sym] = {}.tap do |validation_hash|
          element.elements.each{|child| validation_hash[underscore(child.name).to_sym] = child.text.delete("\n ")}
        end
      end
    end

    def load_base_attributes(country_data, territory)
      territory.attributes.each do |key, value_object|
        country_data[underscore(key).to_sym] = value_object.value
      end
    end

    def load_references(country_data, territory)
      country_data[:references] = territory.css("references sourceUrl").map(&:text)
    end

    def underscore(camel_cased_word)
      return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/
      word = camel_cased_word.to_s.gsub(/::/, '/')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end

    def save_data_file(override: false)
      data_file = override ?  "telephone_number_data_override_file.dat" :  "#{File.dirname(__FILE__)}/../../data/telephone_number_data_file.dat"
      File.open(data_file, 'wb+') { |f| Marshal.dump(@data, f) }
    end
  end
end

