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
		# 	A `VoipfoneClient` object.
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
			JSON.parse(request.body)
		end
	end
end