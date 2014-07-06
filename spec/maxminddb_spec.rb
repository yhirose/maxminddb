require 'maxminddb'

describe MaxMindDB do
  let(:city_db) { MaxMindDB.new('spec/cache/GeoLite2-City.mmdb') }
  let(:country_db) { MaxMindDB.new('spec/cache/GeoLite2-Country.mmdb') }

  context 'for the ip 74.125.225.224' do
    let(:ip) { '74.125.225.224' }

    it 'returns a MaxMindDB::Result' do
      expect(city_db.lookup(ip)).to be_kind_of(MaxMindDB::Result)
    end

    it 'finds data' do
      expect(city_db.lookup(ip)).to be_found
    end

    it 'returns Mountain View as the English name' do
      expect(city_db.lookup(ip).city.name).to eq('Mountain View')
    end

    it 'returns -122.0574 as the longitude' do
      expect(city_db.lookup(ip).location.longitude).to eq(-122.0574)
    end

    it 'returns United States as the English country name' do
      expect(country_db.lookup(ip).country.name).to eq('United States')
    end

    it 'returns US as the country iso code' do
      expect(country_db.lookup(ip).country.iso_code).to eq('US')
    end
  end

  context 'for the ip 2001:708:510:8:9a6:442c:f8e0:7133' do
    let(:ip) { '2001:708:510:8:9a6:442c:f8e0:7133' }

    it 'finds data' do
      expect(city_db.lookup(ip)).to be_found
    end

    it 'returns LV as the country iso code' do
      expect(country_db.lookup(ip).country.iso_code).to eq('LV')
    end
  end

  context 'for the ip 127.0.0.1' do
    let(:ip) { '127.0.0.1' }

    it 'returns a MaxMindDB::Result' do
      expect(city_db.lookup(ip)).to be_kind_of(MaxMindDB::Result)
    end

    it "doesn't find data" do
      expect(city_db.lookup(ip)).to_not be_found
    end
  end
end

# vim: et ts=2 sw=2 ff=unix
