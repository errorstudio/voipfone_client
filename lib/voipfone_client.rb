require 'json'
require 'mechanize'
require 'require_all'
require_rel 'voipfone_client'

module VoipfoneClient
  BASE_URL = "https://www.voipfone.co.uk"
  API_GET_URL = "#{BASE_URL}/api/srv"
  API_POST_URL = "#{BASE_URL}/api/upd"
  TMP_FOLDER = File.join(File.dirname(__FILE__),"..","/tmp")

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
    attr_accessor :username, :password, :user_agent_string, :cache_cookies

    # Configuration initializer, to set up default configuration options
    def initialize
      # By default we cache cookies to a file
      @cache_cookies = true

      # By default we set the user agent string to "VoipfoneClient/[version] http://github.com/errorstudio/voipfone_client"
      @user_agent_string = "VoipfoneClient/#{VoipfoneClient::VERSION} (http://github.com/errorstudio/voipfone_client)"
    end
  end
end
