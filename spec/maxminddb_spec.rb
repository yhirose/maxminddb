require 'maxminddb'

describe MaxMindDB do
  let(:city_db) { MaxMindDB.new('spec/GeoLite2-City.mmdb') }
  let(:country_db) { MaxMindDB.new('spec/GeoLite2-Country.mmdb') }

  context 'for the ip 74.125.225.224' do
    let(:ip) { '74.125.225.224' }

    it 'returns Mountain View as the English name' do
      expect(city_db.lookup(ip)['city']['names']['en']).to eq('Mountain View')
    end

    it 'returns -122.0574 as the longitude' do
      expect(city_db.lookup(ip)['location']['longitude']).to eq(-122.0574)
    end

    it 'returns United States as the English country name' do
      expect(country_db.lookup(ip)['country']['names']['en']).to eq('United States')
    end
  end
end

# vim: et ts=2 sw=2 ff=unix
