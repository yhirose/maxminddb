module MaxMindDB
  class Result
    class Location
      def initialize(raw)
        @raw = Hash(raw)
      end

      def latitude
        raw['latitude']
      end

      def longitude
        raw['longitude']
      end

      def metro_code
        raw['metro_code']
      end

      def time_zone
        raw['time_zone']
      end

      private

      attr_reader :raw
    end
  end
end
