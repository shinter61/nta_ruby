module NtaRuby
  class ConnectionNotFoundError < StandardError
  end

  class Connection
    attr_reader :conn, :id, :version

    def initialize(id:, version:)
      @conn = Faraday.new(:url => 'https://api.houjin-bangou.nta.go.jp') do |builder|
        builder.request  :url_encoded
        builder.response :logger
        builder.adapter  :net_http
      end
      @id = id
      @version = version
    end

    def throw_request(type:, divide:, **option)
      raise ConnectionNotFoundError.new unless conn

      response = []
      case type
      when :number
      when :diff
        from = option[:from].strftime('%Y-%m-%d')
        to = option[:to].strftime('%Y-%m-%d')

        raw_resp = conn.get "#{version}/#{type.to_s}", { id: id, from: from, to: to, divide: (divide || 1), type: '02' }
        result, divide_size = NtaRuby::Response.parse(raw_resp)

        response.concat result

        return response if divide.is_a? Integer

        (1..divide_size).each do |divide_number|
          next if divide_number == 1

          raw_resp = conn.get "#{version}/#{type.to_s}", { id: id, from: from, to: to, divide: divide_number, type: '02' }
          result, _ = NtaRuby::Response.parse(raw_resp)

          response.concat result
        end
      when :name
      else
      end

      response
    end
  end
end
