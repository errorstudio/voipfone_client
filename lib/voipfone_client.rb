require 'json'
require 'mechanize'
require 'voipfone_client/errors'
require 'voipfone_client/client'
require 'voipfone_client/account_balance'
require 'voipfone_client/account_details'
require 'voipfone_client/diverts'
require 'voipfone_client/voicemail'
require 'voipfone_client/sms'

module VoipfoneClient
  BASE_URL = "https://www.voipfone.co.uk"
  API_GET_URL = "https://www.voipfone.co.uk/api/srv"
  API_POST_URL = "https://www.voipfone.co.uk/api/upd"

  class << self
    attr_accessor :configuration
  end

  # A module method which accepts a block, allowing us to configure the module.
  # @param [Block] the configuration block, containing the configuration variables
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  # A configuration class which contains the attributes we want to set in the module method
  class Configuration
    attr_accessor :username, :password, :user_agent_string

    def initialize

    end
  end
end
