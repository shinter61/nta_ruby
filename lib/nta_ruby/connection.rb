module NtaRuby
  class ConnectionNotFoundError < StandardError; end
  class InvalidRequestTypeError < StandardError; end

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

      search_condition = Options.new(type: type, **option).to_h
      search_condition.merge!({ id: id })

      response = []
      case type
      when :number
        raw_resp = conn.get "#{version}/num", search_condition
        result, _ = NtaRuby::Response.parse(raw_resp)

        response.concat result
      when :diff
        raw_resp = conn.get "#{version}/diff", search_condition
        result, divide_size = NtaRuby::Response.parse(raw_resp)

        response.concat result

        return response if divide.is_a? Integer

        (1..divide_size).each do |divide_number|
          next if divide_number == 1

          raw_resp = conn.get "#{version}/diff", search_condition.merge({ divide: divide_number })
          result, _ = NtaRuby::Response.parse(raw_resp)

          response.concat result
        end
      when :name
        raw_resp = conn.get "#{version}/name", search_condition
        result, divide_size = NtaRuby::Response.parse(raw_resp)

        response.concat result

        return response if divide.is_a? Integer

        (1..divide_size).each do |divide_number|
          next if divide_number == 1

          raw_resp = conn.get "#{version}/name", search_condition.merge({ divide: divide_number })
          result, _ = NtaRuby::Response.parse(raw_resp)

          response.concat result
        end
      else
        raise InvalidRequestTypeError.new
      end

      response
    end
  end
end
