require 'sinatra'
require 'maxminddb'

set :bind, '0.0.0.0'

before do
  @db = MaxMindDB.new('/maxminddb/GeoLite2-City.mmdb')
  content_type 'application/json'
end

get '/api' do
  @db.lookup(params[:ip]).to_hash.to_json
end
