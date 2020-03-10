# property_accessor

Ruby syntax sugar for C# style property accessor definition

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'property-accessor'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install property-accessor

## Usage

There are two ways of using property accessor.

You can inject `property` singleton method directly to `Class` object during your app initialization.

```ruby
PropertyAccessor::Mixin.inject!
```

Or you can manually extend your class with `PropertyAccessor` module

```ruby
class Person
  extend PropertyAccessor

  property(:name) do
    get { @name.upcase }
    set { |val| @name = val }
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/estepnv/property-accessor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/estepnv/property-accessor/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the property_accessor project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/estepnv/property-accessor/blob/master/CODE_OF_CONDUCT.md).
