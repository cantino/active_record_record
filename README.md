# ActiveActiveRecordRecord

ActiveRecord Record is a Railtie that instruments ActiveRecord and records SQL queries, model instantiations, and view
renders.  Every request cycle will open a next TextEdit window with a summary of the request.

Note: at the moment this development tool is Mac only.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record_record'
```

And then execute:

    $ bundle

## Usage

Because the instrumentation added by this gem is slow, it remains off by default.  To enable, you must be in the Rails development
environment and provide `COUNT_OBJECTS=true` in the `ENV`.  For example by running:

    $ COUNT_OBJECTS=true rails s

You will often want to reload twice to see an accurate accounting of SQL queries.

You can also wrap a section of code with `track_time_as` to get a breakdown for that section.

```ruby
track_time_as("this block seems slow") do
  10_000.times do
    # SLOW SQL!
    # LOAD ALL THE OBJECTS!
    # RENDER ONE MILLIONS PARTIALS!
  end
end
```

## Development

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/mavenlink/active_record_record/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
