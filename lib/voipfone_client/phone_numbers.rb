module VoipfoneClient
	class Client
    # Return the phone numbers for this account, as strings
    # @return [Array] Phone numbers as strings.
		def phone_numbers
      request = @browser.get("#{VoipfoneClient::API_GET_URL}?nums")
      parse_response(request)["nums"].collect {|n| n.first}
		end
	end
end