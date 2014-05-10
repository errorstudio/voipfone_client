module VoipfoneClient
  class DivertListItem < Client

    #initialise a [DivertListItem], with a name [String] and number [String].
    # @param name [String] The name which appears in dropdowns in the web interface
    # @param number [String] The number which will be called. Spaces will be stripped. + symbol accepted
    def initialize(name: nil, number: nil)
      super!
      @name = name
      @number = number
    end

    # Add a new number to the list of numbers which can be diverted to. Requires a name
    # and a phone number, which will have spaces stripped from it. May be in international
    # format.
    # @return [Boolean] true on success or a failure message (in which case a `VoipfoneAPIError` will be raised)
    def save
      if @name.nil? || @number.nil?
        raise ArgumentError, "You need to include a name and number to add to the diverts list"
      end
      @number = @number.gsub(" ","")
      parameters = {
        "div-list-name" => @name,
        "div-list-num" => number
      }
      request = @browser.post("#{VoipfoneClient::API_POST_URL}?setDivertsList", parameters)
      response = parse_response(request)
      if response == [@name, @number]
        return true
      else
        raise VoipfoneAPIError, "Although Voipfone returned an OK, the data they stored didn't match what you asked for: #{response}"
      end
    end

    class << self
      # Get a list of phones which can be diverted to. Returns a nested array of name and phone number.
      # @return [Array] of names and phone numbers 
      def all
        request = @browser.get("#{VoipfoneClient::API_GET_URL}?divertsCommon")
        parse_response(request)["divertsCommon"]
      end
    end
  end
end