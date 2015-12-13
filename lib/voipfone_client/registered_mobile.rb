module VoipfoneClient
  class RegisteredMobile < Session
    attr_accessor :number, :name

    class << self
      def all
        r = RegisteredMobile.new
        request = r.browser.get("#{VoipfoneClient::API_GET_URL}?registeredMobile")
        r.parse_response(request)[:registeredMobile].collect do |m|
          mobile = RegisteredMobile.new
          mobile.number = m[0]
          mobile.name = m[1]
          mobile
        end
      end
    end
  end
end
