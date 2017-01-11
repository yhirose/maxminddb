require 'maxminddb'

describe MaxMindDB do
  let(:city_db) { MaxMindDB.new('spec/cache/GeoLite2-City.mmdb') }
  let(:country_db) { MaxMindDB.new('spec/cache/GeoLite2-Country.mmdb') }
  let(:rec32_db) { MaxMindDB.new('spec/data/32bit_record_data.mmdb') }

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

    it 'returns nil for is_anonymous_proxy' do
      expect(city_db.lookup(ip).traits.is_anonymous_proxy).to eq(nil)
    end

    it 'returns United States as the English country name' do
      expect(country_db.lookup(ip).country.name).to eq('United States')
    end

    it 'returns US as the country iso code' do
      expect(country_db.lookup(ip).country.iso_code).to eq('US')
    end

    context 'as a Integer' do
      let(:integer_ip) { IPAddr.new(ip).to_i }

      it 'returns a MaxMindDB::Result' do
        expect(city_db.lookup(integer_ip)).to be_kind_of(MaxMindDB::Result)
      end

      it 'returns Mountain View as the English name' do
        expect(city_db.lookup(integer_ip).city.name).to eq('Mountain View')
      end

      it 'returns United States as the English country name' do
        expect(country_db.lookup(integer_ip).country.name).to eq('United States')
      end
    end
  end

  context 'for the ip 2001:708:510:8:9a6:442c:f8e0:7133' do
    let(:ip) { '2001:708:510:8:9a6:442c:f8e0:7133' }

    it 'finds data' do
      expect(city_db.lookup(ip)).to be_found
    end

    it 'returns FI as the country iso code' do
      expect(country_db.lookup(ip).country.iso_code).to eq('FI')
    end

    context 'as an integer' do
      let(:integer_ip) { IPAddr.new(ip).to_i }

      it 'returns FI as the country iso code' do
        expect(country_db.lookup(integer_ip).country.iso_code).to eq('FI')
      end
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

  context 'for 32bit record data' do
    let(:ip) { '1.0.16.1' }

    it 'finds data' do
      expect(rec32_db.lookup(ip)).to be_found
    end
  end

  context 'test ips' do
    [
      ['185.23.124.1', 'SA'],
      ['178.72.254.1', 'CZ'],
      ['95.153.177.210', 'RU'],
      ['200.148.105.119', 'BR'],
      ['195.59.71.43', 'GB'],
      ['179.175.47.87', 'BR'],
      ['202.67.40.50', 'ID'],
    ].each do |ip, iso|
      it 'returns a MaxMindDB::Result' do
        expect(city_db.lookup(ip)).to be_kind_of(MaxMindDB::Result)
      end

      it "returns #{iso} as the country iso code" do
        expect(country_db.lookup(ip).country.iso_code).to eq(iso)
      end
    end
  end

  context 'test boolean data' do
    let(:ip) { '41.194.0.1' }

    it 'returns true for the is_satellite_provider trait' do
      expect(city_db.lookup(ip).traits.is_satellite_provider).to eq(nil)
    end

    # There are no false booleans in the database that we can test.
    # False values are simply omitted.
  end
end

# vim: et ts=2 sw=2 ff=unix
