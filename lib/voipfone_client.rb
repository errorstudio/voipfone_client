require "voipfone_client/version"

module VoipfoneClient
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :username, :password

    def initialize
    	
    end
  end
end
