class VoipfoneClient::Client
	#  Intantiates a new Voipfone client, with optional username and password.
	#  If no username / password is supplied here, one is expected in the configuration block.
	# == Parameters:
	# 	username::
	# 		A string for the email you log into Voipfone with
	#
	# 	password::
	# 		A string for the password you log into Voipfone with
	#
	# == Returns:
	# 	A `VoipfoneClient::Client` object.
	#
	def initialize()
		if VoipfoneClient.configuration.username.nil? || VoipfoneClient.configuration.password.nil?
			raise LoginCredentialsMissing, "You need to include a username and password to log in."
		end
		username = VoipfoneClient.configuration.username
		password = VoipfoneClient.configuration.password
		@browser = Mechanize.new
		login_url = "#{VoipfoneClient::BASE_URL}/login.php?method=process"
		@browser.post(login_url,{"hash" => "urlHash", "login" => username, "password" => password})
	end

	private
	# Responses from the private Voipfone API are always in the form ["message", {content}]
	# We will strip the message (hopefully "OK"), raise if not OK, and return the content.
	# == Parameters:
	# 	request::
	# 		The raw request response from the Voipfone API
	#
	# == Returns:
	# 	A Ruby hash of parsed JSON
	# 
	def parse_response(request)
		raw = JSON.parse(request.body)
		unless raw.first == "ok" || raw.first == "OK"
			raise VoipfoneAPIError, raw.first
		end
		raw.last
	end
end