module VoipfoneClient
	class Client
		#  Intantiates a new Voipfone client, with optional username and password.
		#  If no username / password is supplied here, one is expected in the configuration block.
		# == Parameters::
		# 	username::
		# 		A string for the email you log into Voipfone with
		# 	password::
		# 		A string for the password you log into Voipfone with
		# == Returns::
		# 	A `VoipfoneClient::Client` object.
		#
		def initialize(username: nil, password: nil)
			if username.nil? || password.nil?
				raise LoginCredentialsMissing, "You need to include a username and password to log in."
				username = self.configuration.username
				password = self.configuration.password
			end
			@browser = Mechanize.new
			login_url = "https://www.voipfone.co.uk/login.php?method=process"
			@browser.post(login_url,{"hash" => "urlHash", "login" => username, "password" => password})
		end

		def account_balance
			request = @browser.get("https://www.voipfone.co.uk/api/srv?balance&builder")
			parse_response(request)["balance"]
		end

		private
		# Responses from the private Voipfone API are always in the form ["message", {content}]

		# We will strip the message (hopefully "OK"), raise if not OK, and return the content.

		# == Parameters::
		# 	request::
		# 		The raw request response from the Voipfone API
		# == Returns::
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
end