require_relative 'result/location'
require_relative 'result/named_location'
require_relative 'result/postal'

module MaxMindDB
  class Result
    def initialize(raw)
      @raw = raw || {}
    end

    def [](attr)
      raw[attr]
    end

    def city
      @_city ||= NamedLocation.new(raw['city'])
    end

    def continent
      @_continent ||= NamedLocation.new(raw['continent'])
    end

    def country
      @_country ||= NamedLocation.new(raw['country'])
    end

    def found?
      !raw.empty?
    end

    def location
      @_location ||= Location.new(raw['location'])
    end

    def postal
      @_postal ||= Postal.new(raw['postal'])
    end

    def registered_country
      @_registered_country ||= NamedLocation.new(raw['registered_country'])
    end

    def subdivisions
      @_subdivisions ||= Array(raw['subdivisions']).map { |hash| NamedLocation.new(hash) }
    end

    private

    attr_reader :raw
  end
end
