# coding: utf-8
module VoipfoneClient
  class Session
    attr_reader :browser
    # Intantiates a new Voipfone client, with username and password from the [VoipfoneClient::Configuration] class
    # @return [VoipfoneClient::Client] the object created
    def initialize
      if VoipfoneClient.configuration.username.nil? || VoipfoneClient.configuration.password.nil?
        raise LoginCredentialsMissing, "You need to include a username and password to log in."
      end
      @browser = Mechanize.new
      @browser.user_agent = VoipfoneClient.configuration.user_agent_string
      login()
    end

    # check if the user is authenticated. This is a little convoluted because the voipfone private API
    # always returns '200 OK', but returns 'authfirst' for every response if there is no authentication.
    # So we make a request to a simple endpoint and expect an empty hash; if we get 'authfirst' we're not authenticated
    # @return [Boolean] to identify whether we're authenticated or not.
    def authenticated?
      request = @browser.get("#{VoipfoneClient::API_GET_URL}?builder")
      response = parse_response(request)[:builder]
      if response == "authfirst"
        return false
      else
        return true
      end
    end

    # login to Voipfone, using the configured username and password. 
    # Unless explicitly specified, this method caches cookies on disk to
    # allow classes inheriting {Voipfone::Session} to use these instead of
    # logging in each time.
    # @return [Boolean] true on success or {NotAuthenticatedError} on failure
    def login
      username = VoipfoneClient.configuration.username
      password = VoipfoneClient.configuration.password
      cookie_file = File.join(VoipfoneClient::TMP_FOLDER,"voipfone_client_cookies.yaml")

      # load existing cookies from the file on disk
      if File.exists?(cookie_file)
        @browser.cookie_jar.load(cookie_file)
      end

      # if we're authenticated at this point, we're done.
      return true if authenticated?

      # …otherwise we need to login to the service
      login_url = "#{VoipfoneClient::BASE_URL}/login.php?method=process"
      @browser.post(login_url,{"hash" => "urlHash", "login" => username, "password" => password})

      # If we're authenticated at this point, save the cookies and return true
      if authenticated?
        @browser.cookie_jar.save(cookie_file, session: true)
        return true
      # otherwise, we've tried to authenticate and failed, which means we have a 
      # bad username / password combo and it's time to raise an error.
      else
        raise NotAuthenticatedError, "Username or Password weren't accepted."
      end
    end

    # Responses from the private Voipfone API are always in the form ["message", {content}]
    # We will strip the message (hopefully "OK"), raise if not OK, and return the content.
    # One exception - call records do not follow this convention and therefore
    # a different approach is used for these.
    # @param request [JSON] The raw request response from the Voipfone API
    # @return [Hash] the parsed JSON
    def parse_response(request)
      raw = JSON.parse(request.body, symbolize_names: true)
      unless raw.first == "ok" || raw.first == "OK"
        raise VoipfoneAPIError, raw.first
      end
      raw.last
    end
  end
end
