require "nta_ruby/version"
require "nta_ruby/connection"
require "nta_ruby/response"
require "faraday"
require "csv"

module NtaRuby
  class << self
    def new(id, version = 4)
      NtaRuby::Connection.new(id: id, version: version)
    end
  end
end
