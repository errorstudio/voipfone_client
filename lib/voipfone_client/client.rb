module VoipfoneClient
	class Client
		attr_reader :browser
		#  Intantiates a new Voipfone client, with username and password from the `VoipfoneClient::Configuration` class
		# @return [VoipfoneClient::Client] the object created
		def initialize()
			if VoipfoneClient.configuration.username.nil? || VoipfoneClient.configuration.password.nil?
				raise LoginCredentialsMissing, "You need to include a username and password to log in."
			end
			username = VoipfoneClient.configuration.username
			password = VoipfoneClient.configuration.password
			@browser = Mechanize.new
			login_url = "#{VoipfoneClient::BASE_URL}/login.php?method=process"
			@browser.post(login_url,{"hash" => "urlHash", "login" => username, "password" => password})
			#We'll do a call to a cheap endpoint (the balance) and if it returns 'authfirst', there's a problem
			#with the username / password. Oddly it still returns 200 OK.
			if account_balance == "authfirst"
				raise NotAuthenticatedError, "Username or Password weren't accepted. You'll need to instantiate a new VoipfoneClient::Client object."
			end
		end

		private
		# Responses from the private Voipfone API are always in the form ["message", {content}]
		# We will strip the message (hopefully "OK"), raise if not OK, and return the content.
		# @param request [JSON] The raw request response from the Voipfone API
		# @return [Hash] the parsed JSON
		def parse_response(request)
			raw = JSON.parse(request.body)
			unless raw.first == "ok" || raw.first == "OK"
				raise VoipfoneAPIError, raw.first
			end
			raw.last
		end
	end
end