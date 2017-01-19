# TelephoneNumber

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/telephone_number`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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
    
## Configuration

In the event that you need to override the data that Google is providing, you can do so by setting an override file. This file is expected to be in the same format as Google's as well as serialized using Marshal. 

To generate a serialized override file: 

    TelephoneNumber.generate_override_file("/path/to/file")
    
In this instance, `/path/to/file` represents an xml file that has your custom data in the same structure that Google's data is in.

You can set the override file with:
    
    TelephoneNumber.override_file = "/path/to_file.dat"

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mobi/telephone_number. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

