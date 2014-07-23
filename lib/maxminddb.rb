require "maxminddb/version"
require 'maxminddb/result'
require 'ipaddr'

module MaxMindDB

  def self.new(path)
    Client.new(path)
  end

  class Client
    METADATA_BEGIN_MARKER = ([0xAB, 0xCD, 0xEF].pack('C*') + 'MaxMind.com').encode('ascii-8bit', 'ascii-8bit')
    DATA_SECTION_SEPARATOR_SIZE = 16
    SIZE_BASE_VALUES = [0, 29, 285, 65821]
    POINTER_BASE_VALUES = [0, 0, 2048, 526336]

    def initialize(path)
      @path = path
      @data = File.open(path, "rb:ascii-8bit").read

      pos = @data.rindex(METADATA_BEGIN_MARKER)
      raise 'invalid file format' unless pos
      pos += METADATA_BEGIN_MARKER.size

      @metadata = decode(pos, 0)[1]
      @metadata['node_byte_size'] = @metadata['record_size'] * 2 / 8
      @metadata['search_tree_size'] = @metadata['node_count'] * @metadata['node_byte_size']
    end

    def inspect
      "#<MaxMindDB::Client: DBPath:'#{@path}'>"
    end

    def lookup(ip)
      node_no = 0
      addr = addr_from_ip(ip)
      for i in 0 ... 128
        flag = (addr >> (127 - i)) & 1
        record = read_record(node_no, flag)
        if record == @metadata['node_count']
          return MaxMindDB::Result.new(nil)
        elsif record > @metadata['node_count']
          data_section_start = @metadata['search_tree_size'] + DATA_SECTION_SEPARATOR_SIZE;
          pos = (record - @metadata['node_count']) - DATA_SECTION_SEPARATOR_SIZE
          return MaxMindDB::Result.new(decode(pos, data_section_start)[1])
        end
        node_no = record
      end
      raise 'invalid file format'
    end

    private

    def read_record(node_no, flag)
      node_byte_size = @metadata['node_byte_size']
      rec_byte_size = node_byte_size / 2
      pos = node_byte_size * node_no
      middle = @data[pos + rec_byte_size, 1].unpack('C')[0] if node_byte_size.odd?
      if flag == 0
        val = read_value(pos, 0, rec_byte_size)[1]
        val + ((middle >> 4 & 0x7) << 24) if middle
      else
        val = read_value(pos + node_byte_size - rec_byte_size, 0, rec_byte_size)[1]
        val + ((middle & 0x7) << 24) if middle
      end
      val
    end

    def decode(pos, base_pos)
      ctrl = @data[pos + base_pos].unpack('C')[0]
      pos += 1

      type = ctrl >> 5

      if type == 1 # pointer
        size = ((ctrl >> 3) & 0x3) + 1
        v1 = ctrl & 0x7
        pos, v2 = read_value(pos, base_pos, size)

        pointer = (v1 << (8 * size)) + v2 + POINTER_BASE_VALUES[size]
        val = decode(pointer, base_pos)[1]
      else
        if type == 0 # extended type
          type = 7 + @data[pos + base_pos].unpack('C')[0]
          pos += 1
        end

        size = ctrl & 0x1f
        if size >= 29
          byte_size = size - 29 + 1
          pos, val = read_value(pos, base_pos, byte_size)
          size = val + SIZE_BASE_VALUES[byte_size]
        end

        case type
        when 2 # utf8
          val = @data[pos + base_pos, size].encode('utf-8', 'utf-8')
          pos += size
        when 3 # double
          val = @data[pos + base_pos, size].unpack('G')[0]
          pos += size
        when 4 # bytes
          val = @data[pos + base_pos, size]
          pos += size
        when 5 # unsigned 16-bit int
          pos, val = read_value(pos, base_pos, size)
        when 6 # unsigned 32-bit int
          pos, val = read_value(pos, base_pos, size)
        when 7 # map
          val = {}
          size.times do
            pos, k = decode(pos, base_pos)
            pos, v = decode(pos, base_pos)
            val[k] = v
          end
        when 8 # signed 32-bit int
          v1 = @data[pos + base_pos, size].unpack('N')[0]
          bits = size * 8
          val = (v1 & ~(1 << bits)) - (v1 & (1 << bits))
          pos += size
        when 9 # unsigned 64-bit int
          pos, val = read_value(pos, base_pos, size)
        when 10 # unsigned 128-bit int
          pos, val = read_value(pos, base_pos, size)
        when 11 # array
          val = []
          size.times do
            pos, v = decode(pos, base_pos)
            val.push(v)
          end
        when 12 # data cache container
          raise 'TODO:'
        when 13 # end marker
          val = nil
        when 14 # boolean
          val = size ? true : false
        when 15 # float
          val = @data[pos + base_pos, size].unpack('g')[0]
          pos += size
        end
      end

      [pos, val]
    end

    def read_value(pos, base_pos, size)
      bytes = @data[pos + base_pos, size].unpack('C*')
      val = bytes.inject(0){|r, v| (r << 8) + v }
      [pos + size, val]
    end

    def addr_from_ip(ip)
      klass = ip.class
      if klass == Fixnum || klass == Bignum
        ip
      else
        addr = IPAddr.new(ip)
        addr = addr.ipv4_compat if addr.ipv4?
        addr.to_i
      end
    end
  end
end

# vim: et ts=2 sw=2 ff=unix
