require 'json'
require 'mechanize'
require 'voipfone_client/errors'
require 'voipfone_client/client'
require 'voipfone_client/account_balance'
require 'voipfone_client/account_details'

module VoipfoneClient
  BASE_URL = "https://www.voipfone.co.uk"
  API_URL = "https://www.voipfone.co.uk/api/srv"
end
