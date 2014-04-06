class VoipfoneClient::Client
	# Return the basic account details, as stored by Voipfone.
	# == Returns::
	# 	A hash of account details.
	def account_details
		request = @browser.get("#{VoipfoneClient::API_URL}?account")
		parse_response(request)
	end
end