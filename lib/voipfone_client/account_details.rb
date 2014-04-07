class VoipfoneClient::Client
	# Return the basic account details, as stored by Voipfone.
  # @return [Hash] of account details
	def account_details
		request = @browser.get("#{VoipfoneClient::API_GET_URL}?account")
		parse_response(request)
	end
end