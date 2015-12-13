module VoipfoneClient
  class Extension < Session
    attr_accessor( :number, :name, :email, :password, :group, :voicemail,
                   :business_hours, :recording)

    # Constructor for {Extension} which accepts the number, email,
    # password, group, voicemail, business hours and recording
    # settings.

    # @param number [String] the number of the phone extension.
    # @param name [String] the name of the person at that extension.
    # @param email [String] the email address of that person.
    # @param password [String] the six-digit password of the phone extension.

    # @param group [Boolean] does the extension belong to the default group?
    # @param voicemail [Boolean] does the extension have voicemail?
    # @param business_hours [Boolean] only available during business hours?
    # @param recording [Boolean] are the calls to be recorded?
    
    def initialize( number: nil, name: nil, email: nil, password: nil,
                    group: false, voicemail: false, business_hours: false,
                    recording: false)
      @number = number
      @name = name
      @email = email
      @password = password
      @group = group
      @voicemail = voicemail
      @business_hours = business_hours
      @recording = recording
      super()
    end

    class << self
      # Get a list of extensions. Returns a nested array of extensions
      # and details.
      # @return [Array] of Extensions with numbers, names, passwords, and
      # boolean values for group, voicemail, business_hours and recording
      # settings

      def all
        session = self.new
        request = session.browser.get("#{VoipfoneClient::API_GET_URL}?ext")
        session.parse_response(request)[:ext].collect do |e|
          { number: e[0], name: e[1], email: e[2],
            password: e[3], group: e[4], voicemail: e[5],
            business_hours: e[6], recording: e[7]}
        end
      end

      # Get a simple list of extensions. Returns a list of extension
      # numbers as an array of strings.
      # @return [Array] of extension numbers

      def list
        session = self.new
        request = session.browser.get("#{VoipfoneClient::API_GET_URL}?ext")
        session.parse_response(request)[:ext].collect do |e|
          e[0]
        end
      end
    end
  end
end
