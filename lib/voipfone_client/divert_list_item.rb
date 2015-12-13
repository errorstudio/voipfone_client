module VoipfoneClient
  class DivertListItem < Session
    attr_accessor :name, :number

    # Constructor for {DivertListItem} which accepts the name and number of the phone number to add to the diverts list.
    # @param name [String] the name of the phone to be diverted to
    # @param number [String] the number of the phone to be diverted to.
    def initialize(name: nil, number: nil)
      @name = name
      @number = number
      super()
    end

    # Add a new number to the list of numbers which can be diverted to. Requires a name
    # and a phone number, which will have spaces stripped from it. May be in international
    # format.
    # @return [Boolean] true on success or a failure message (in which case a {VoipfoneAPIError} will be raised)
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
        d = self.new
        request = d.browser.get("#{VoipfoneClient::API_GET_URL}?divertsCommon")
        d.parse_response(request)[:divertsCommon].collect do |i|
          DivertListItem.new(name: i.first, number: i.last)
        end
      end
    end
  end
end
