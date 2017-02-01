[![Code Climate](https://codeclimate.com/github/mobi/telephone_number/badges/gpa.svg)](https://codeclimate.com/github/mobi/telephone_number)

# What is it?

TelephoneNumber is global phone number validation gem based on Google's [libphonenumber](https://github.com/googlei18n/libphonenumber) library. We're currently providing parsing and validation functionality and are actively working on formatting as well as providing extended data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'telephone_number'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install telephone_number

## Usage

TelephoneNumber requires a country when parsing and validating phone numbers.

**To validate a phone number:**

    TelephoneNumber.valid?("(555) 555-5555", "US") ==> false

You can pass an optional array of keys to check the validity against.

    TelephoneNumber.valid?("(555) 555-5555", "US", [:mobile, :fixed_line]) ==> false

**To parse a phone number:**

    TelephoneNumber.parse("(317) 508-3348", "US") ==>

        #<TelephoneNumber::Number:0x007fe3bc146cf0
          @country="US",
          @e164_number="13175083348",
          @national_number="3175083348",
          @original_number="3175083348">

**To fetch valid types:**

    TelephoneNumber.parse("(317) 508-3348", "US").valid_types ==>  ["mobile", "fixed_line"]

**To format nationally:**

    TelephoneNumber.parse("(317) 508-3348", "US").national_number ==> "(317) 508-3348"
    TelephoneNumber.parse("(317) 508-3348", "US").national_number(formatted: false) ==> "3175083348"

## Configuration

In the event that you need to override the data that Google is providing, you can do so by setting an override file. This file is expected to be in the same format as Google's as well as serialized using Marshal.

To generate a serialized override file:

    TelephoneNumber.generate_override_file("/path/to/file")

In this instance, `/path/to/file` represents an xml file that has your custom data in the same structure that Google's data is in.

You can set the override file with:

    TelephoneNumber.override_file = "/path/to_file.dat"

## Todo

- Build custom validator to integrate with Rails
- Build formatting functionality
- Build extended data functionality(short codes, carrier data, etc.)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

While developing new functionality, you may want to test against specific phone numbers. In order to do this, add the number to `lib/telephone_number/test_data_generator.rb` and then run `rake data:test:import`. This command will reach out to the demo application provided by Google and pull the correct formats to test against.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mobi/telephone_number. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

