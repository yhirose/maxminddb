require 'maxminddb'

describe MaxMindDB do
  IP = '74.125.225.224'

  before do
    @mmdb = MaxMindDB.new('spec/GeoLite2-City.mmdb')
  end

  it 'should ' do
    @mmdb.lookup(IP)['city']['names']['en'].should == 'Mountain View'
    @mmdb.lookup(IP)['location']['longitude'].should == -122.0574
  end
end

# vim: et ts=2 sw=2 ff=unix
