# GeoLite2

Pure Ruby MaxMind [GeoLite2](http://dev.maxmind.com/geoip/geoip2/geolite2/) database reader.

## Installation

Add this line to your application's Gemfile:

    gem 'geolite2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install geolite2

## Usage

    db = GeoLite2.new('./GeoLite2-City.mmdb')
    ret = db.lookup('123.456.789.012');
    if ret
        country_name = ret['country']['names']['en']
        country_iso_code = ret['country']['iso_code']
        city_name = ret['city']['names']['en']
        latitude = ret['location']['latitude']
    end

## Contributing

1. Fork it ( http://github.com/yhirose/geolite2/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
