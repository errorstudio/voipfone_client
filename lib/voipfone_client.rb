require 'json'
require 'mechanize'
require 'voipfone_client/errors'
require 'voipfone_client/client'
require 'voipfone_client/account_balance'
require 'voipfone_client/account_details'
require 'voipfone_client/diverts'

module VoipfoneClient
  BASE_URL = "https://www.voipfone.co.uk"
  API_GET_URL = "https://www.voipfone.co.uk/api/srv"
  API_POST_URL = "https://www.voipfone.co.uk/api/upd"
end
