require 'json'
require 'mechanize'
require 'voipfone_client/errors'
require 'voipfone_client/client'
require 'voipfone_client/account_balance'
require 'voipfone_client/account_details'
require 'voipfone_client/diverts'
require 'voipfone_client/voicemail'

module VoipfoneClient
  BASE_URL = "https://www.voipfone.co.uk"
  API_GET_URL = "https://www.voipfone.co.uk/api/srv"
  API_POST_URL = "https://www.voipfone.co.uk/api/upd"

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :username, :password, :user_agent_string

    def initialize

    end
  end
end
