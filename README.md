# maxminddb

Pure Ruby [MaxMind DB](http://maxmind.github.io/MaxMind-DB/) binary file reader.

[![Gem Version](https://badge.fury.io/rb/maxminddb.svg)](http://badge.fury.io/rb/maxminddb)
[![Build Status](https://travis-ci.org/yhirose/maxminddb.svg?branch=master)](https://travis-ci.org/yhirose/maxminddb)
[![Code Climate](https://codeclimate.com/github/yhirose/maxminddb.png)](https://codeclimate.com/github/yhirose/maxminddb)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'maxminddb'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install maxminddb
```

## Usage

```ruby
db = MaxMindDB.new('./GeoLite2-City.mmdb')
ret = db.lookup('74.125.225.224')

ret.found? # => true
ret.country.name # => 'United States'
ret.country.name('zh-CN') # => '美国'
ret.country.iso_code # => 'US'
ret.city.name(:fr) # => 'Mountain View'
ret.location.latitude # => -122.0574
```

Even if no result could be found, you can ask for the attributes without guarding for nil:

```ruby
db = MaxMindDB.new('./GeoLite2-City.mmdb')
ret = db.lookup('127.0.0.1')
ret.found? # => false
ret.country.name # => nil
```


## Contributing

1. Fork it ( http://github.com/yhirose/maxminddb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
