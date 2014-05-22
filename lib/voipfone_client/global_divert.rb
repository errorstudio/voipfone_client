module VoipfoneClient
  # Set up a global (whole-account) divert on your account.
  # You need to specify the type of divert and the number to which the divert will go to.
  # There are 4 supported situations which can be
  # diverted for, namely:
  #  - all calls (i.e. no calls will reach the pbx / phones - immediate divert)
  #  - when there is a failure in the phone system
  #  - when the phone(s) are busy
  #  - when there's no answer
  class GlobalDivert < Session
    attr_accessor :type, :number

    # Constructor for {GlobalDivert} which allows you to pass in a {DivertListItem} to be used as the receiving number.
    # @param divert_list_item [DivertListItem] a {DivertListItem} object which will be used to fill the {GlobalDivert} number.
    # You still need to specify the divert type.
    def initialize(divert_list_item = nil)
      if divert_list_item.is_a?(DivertListItem)
        @number = divert_list_item.number
      end
      super()
    end

    # A hash of voipfone divert names vs our divert names. Note that when we query
    # voipfone the returned value of the divert type is UPPERCASE.
    VOIPFONE_DIVERT_NAMES = {
      "all" => "all",
      "chanunavail" => "fail",
      "busy" => "busy",
      "noanswer" => "no_answer"
    }

    #Save the divert on your account
    # @return [Boolean] true on success, or a failure message (in which case a {VoipfoneAPIError} will be raised)
    def save
      if @type.nil? || @number.nil?
        raise ArgumentError, "You need to set a divert type and divert number before you can save the divert."
      end
      set_diverts(@type => @number)
    end

    #Clear all diverts
    # @return [Boolean] true on success, or a failure message (in which case a {VoipfoneAPIError} will be raised)
    def clear!
      set_diverts()
    end
    class << self
      # Get current diverts
      # @return [Array] A nested set of arrays with divert information for each type of divert currently set
      def all
        g = self.new
        request = g.browser.get("#{VoipfoneClient::API_GET_URL}?divertsMain")
        g.parse_response(request)["divertsMain"].collect do |d|
          divert = GlobalDivert.new
          divert.number = d[1]
          divert.type = VOIPFONE_DIVERT_NAMES[d[2].downcase].to_sym
          divert
        end
      end
    end

    private
    # Divert calls for different circumstances. There are 4 supported situations which can be
    # diverted for, namely:
    #  - all calls (i.e. no calls will reach the pbx / phones - immediate divert)
    #  - when there is a failure in the phone system
    #  - when the phone(s) are busy
    #  - when there's no answer
    # If no values are passed, all diverts are cleared.
    # @param all [String] The number to which all calls will be diverted.
    # @param fail [String] The number to which calls will be diverted in the event of a failure
    # @param busy [String] The number to which calls will be diverted if the phones are busy
    # @param no_answer [String] The number to which calls will be diverted if there's no answer
    # @return [Boolean] true on success, or a failure message (in which case a {VoipfoneAPIError} will be raised)
    def set_diverts(all: nil, fail: nil, busy: nil, no_answer: nil)
      all ||= ""
      fail ||= ""
      busy ||= ""
      no_answer ||= ""
      parameters = {
        "all" => all.gsub(" ",""),
        "chanunavail" => fail.gsub(" ",""),
        "busy" => busy.gsub(" ",""),
        "noanswer" => no_answer.gsub(" ","")
      }
      request = @browser.post("#{VoipfoneClient::API_POST_URL}?divertsMain", parameters)
      response = parse_response(request)
      if response == "ok"
        return true
      else
        raise VoipfoneAPIError, response.first
      end
    end
  end
end




    


