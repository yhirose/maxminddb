require 'maxminddb'

describe MaxMindDB do
  IP = '74.125.225.224'

  before do
    @city = MaxMindDB.new('spec/GeoLite2-City.mmdb')
    @country = MaxMindDB.new('spec/GeoLite2-Country.mmdb')
  end

  it 'should ' do
    @city.lookup(IP)['city']['names']['en'].should == 'Mountain View'
    @city.lookup(IP)['location']['longitude'].should == -122.0574

    @country.lookup(IP)['country']['names']['en'].should == 'United States'
  end
end

# vim: et ts=2 sw=2 ff=unix
