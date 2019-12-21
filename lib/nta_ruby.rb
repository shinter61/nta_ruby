require "nta_ruby/version"
require "nta_ruby/connection"
require "faraday"

module NtaRuby
  class << self
    def new(id, version = 4)
      NtaRuby::Connection.new(id: id, version: version)
    end
  end
end
