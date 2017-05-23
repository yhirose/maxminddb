# maxminddb

Pure Ruby [GeoIP2 MaxMind DB](http://maxmind.github.io/MaxMind-DB/) reader, which doesn't require [libmaxminddb](https://github.com/maxmind/libmaxminddb).

You can find more information about the GeoIP2 database [here](http://dev.maxmind.com/geoip/geoip2/downloadable/).

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
ret.to_hash # => {"city"=>{"geoname_id"=>5375480, "names"=>{"de"=>"Mountain View", "en"=>"Mountain View", "fr"=>"Mountain View", "ja"=>"マウンテンビュー", "ru"=>"Маунтин-Вью", "zh-CN"=>"芒廷维尤"}}, "continent"=>{"code"=>"NA", "geoname_id"=>6255149, "names"=>{"de"=>"Nordamerika", "en"=>"North America", "es"=>"Norteamérica", "fr"=>"Amérique du Nord", "ja"=>"北アメリカ", "pt-BR"=>"América do Norte", "ru"=>"Северная Америка", "zh-CN"=>"北美洲"}}, "country"=>{"geoname_id"=>6252001, "iso_code"=>"US", "names"=>{"de"=>"USA", "en"=>"United States", "es"=>"Estados Unidos", "fr"=>"États-Unis", "ja"=>"アメリカ合衆国", "pt-BR"=>"Estados Unidos", "ru"=>"Сша", "zh-CN"=>"美国"}}, "location"=>{"latitude"=>37.419200000000004, "longitude"=>-122.0574, "metro_code"=>807, "time_zone"=>"America/Los_Angeles"}, "postal"=>{"code"=>"94043"}, "registered_country"=>{"geoname_id"=>6252001, "iso_code"=>"US", "names"=>{"de"=>"USA", "en"=>"United States", "es"=>"Estados Unidos", "fr"=>"États-Unis", "ja"=>"アメリカ合衆国", "pt-BR"=>"Estados Unidos", "ru"=>"Сша", "zh-CN"=>"美国"}}, "subdivisions"=>[{"geoname_id"=>5332921, "iso_code"=>"CA", "names"=>{"de"=>"Kalifornien", "en"=>"California", "es"=>"California", "fr"=>"Californie", "ja"=>"カリフォルニア州", "pt-BR"=>"Califórnia", "ru"=>"Калифорния", "zh-CN"=>"加利福尼亚州"}}]}
```

Even if no result could be found, you can ask for the attributes without guarding for nil:

```ruby
db = MaxMindDB.new('./GeoLite2-City.mmdb')
ret = db.lookup('127.0.0.1')
ret.found? # => false
ret.country.name # => nil
ret.to_hash # => {}
```

It's also possible to access the database metadata.

```ruby
db = MaxMindDB.new('./GeoLite2-City.mmdb')
db.metadata['build_epoch'] # => 1493762948
db.metadata # => {"binary_format_major_version"=>2, "binary_format_minor_version"=>0, "build_epoch"=>1493762948, "database_type"=>"GeoLite2-City", "description"=>{"en"=>"GeoLite2 City database"}, "ip_version"=>6, "languages"=>["de", "en", "es", "fr", "ja", "pt-BR", "ru", "zh-CN"], "node_count"=>3678850, "record_size"=>28}
```


## Contributing

1. Fork it ( http://github.com/yhirose/maxminddb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
