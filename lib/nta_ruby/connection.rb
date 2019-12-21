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

    def throw_request(type:, **option)
      raise ConnectionNotFoundError.new unless conn

      case type
      when :number
      when :diff
        from = option[:from].strftime('%Y-%m-%d')
        to = option[:to].strftime('%Y-%m-%d')
        resp = conn.get "#{version}/#{type.to_s}", { id: id, from: from, to: to, divide: 1, type: '02' }
      when :name
      else
      end

      puts resp.body
    end
  end
end
