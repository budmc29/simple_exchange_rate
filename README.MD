# Simple Exchange Rate

Simple exchange rate library using `www.ecb.europa.eu` as an API and XML as a file store.  
Just for fun and profit.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_exchange_rate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_exchange_rate

## Usage

```ruby
require 'simple_exchange_rate'

SimpleExchangeRate.at(Date.today, 'USD', 'GBP')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/budmc29/simple_exchange_rate.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

