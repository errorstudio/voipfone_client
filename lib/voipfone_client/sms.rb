module VoipfoneClient
  class SMS < Session
    attr_accessor :from, :to, :message

    # Constructor to create an SMS - optionally pass in to, from and message
    # @param to [String] the phone number to send the SMS to, as a string. Spaces will be stripped; + symbol allowed.
    # @param from [String] the phone number to send the SMS from, as a string. Spaces will be stripped; + symbol allowed.
    # @param message [String] the message to send. The first 160 characters only will be sent.
    def initialize(to: nil, from: nil, message: nil)
      @to = to
      @from = from
      @message = message
      super()
    end

    # Send an sms from your account.
    def send
      if @to.nil? || @from.nil? || @message.nil?
        raise ArgumentError, "You need to include 'to' and 'from' numbers and a message to send an SMS"
      end
      to = @to.gsub(" ","")
      from = @from.gsub(" ","")
      parameters = {
        "sms-send-to" => to,
        "sms-send-from" => from,
        "sms-message" => @message[0..159]
      }
      request = @browser.post("#{VoipfoneClient::API_POST_URL}?smsSend",
                              parameters)
      response = parse_response(request)
      if response == "ok"
        return true
      else
        raise VoipfoneAPIError, response
      end
    end
  end
end
