module VoipfoneClient
  class Account < Session
    # Return the balance of the account as a float.
    # @return [Float] Account balance as a float. Should be rounded to 2dp before presentation.     
    def balance
      request = @browser.get("#{VoipfoneClient::API_GET_URL}?balance&builder")
      parse_response(request)[:balance]
    end

    def details
      request = @browser.get("#{VoipfoneClient::API_GET_URL}?account")
      parse_response(request)
    end

    # Return the phone numbers for this account, as strings
    # @return [Array] Phone numbers as strings.
    def phone_numbers
      request = @browser.get("#{VoipfoneClient::API_GET_URL}?nums")
      parse_response(request)[:nums].collect {|n| n.first}
    end

    # Get a simple list of extensions. Returns a list of extension
    # numbers as an array of strings. As this may be required
    # multiple times for report generation and other uses, this call
    # is cached.  See Extension.all for an uncached list.
    # @return [Array] of extension numbers
    def extension_numbers
      Extension.list
    end

    #Return a list of voicemail entries, with details for each
    #@return [Hash] of voicemail information. This includes a reference to a WAV file which isn't accessible (yet?)
    def voicemail
      request = @browser.get("#{VoipfoneClient::API_GET_URL}?vm_view")
      parse_response(request)[:vm_view].first[:voicemail]
    end
  end
end
