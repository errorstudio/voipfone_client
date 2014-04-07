class VoipfoneClient::Client
  # Get a list of phones which can be diverted to. Returns a nested array of name and phone number.
  # @return [Array] of names and phone numbers 
  def diverts_list
    request = @browser.get("#{VoipfoneClient::API_GET_URL}?divertsCommon")
    parse_response(request)["divertsCommon"]
  end

  # Add a new number to the list of numbers which can be diverted to. Requires a name
  # and a phone number, which will have spaces stripped from it. May be in international
  # format.
  # @param name [String] The name which appears in dropdowns in the web interface
  # @param number [String] The number which will be called. Spaces will be stripped. + symbol accepted
  # @return [Boolean] true on success or a failure message (in which case a `VoipfoneAPIError` will be raised)
  def add_to_diverts_list(name: nil, number: nil)
    if name.nil? || number.nil?
      raise ArgumentError, "You need to include a name and number to add to the diverts list"
    end
    number = number.gsub(" ","")
    parameters = {
      "div-list-name" => name,
      "div-list-num" => number
    }
    request = @browser.post("#{VoipfoneClient::API_POST_URL}?setDivertsList", parameters)
    response = parse_response(request)
    if response == [name, number]
      return true
    else
      raise VoipfoneAPIError, "Although Voipfone returned an OK, the data they stored didn't match what you asked for: #{response}"
    end
  end


  # Divert calls for different circumstances - at least one option is required. There are 4 supported situations which can be
  # diverted for, namely:
  #  - all calls (i.e. no calls will reach the pbx / phones - immediate divert)
  #  - when there is a failure in the phone system
  #  - when the phone(s) are busy
  #  - when there's no answer
  # @param all [String] The number to which all calls will be diverted.
  # @param fail [String] The number to which calls will be diverted in the event of a failure
  # @param busy [String] The number to which calls will be diverted if the phones are busy
  # @param no_answer [String] The number to which calls will be diverted if there's no answer
  # @return [Boolean] true on success, or a failure message (in which case a `VoipfoneAPIError` will be raised)
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

  # Diverts all calls to the number passed into this method
  # @param number [String] The number to be diverted to.
  # @return [Boolean] true on success, or an error message (in which case a `VoipfoneAPIError` will be raised)
  def divert_all_calls(number: nil)
    set_diverts(all: number)
  end

  # Get current diverts
  # @return [Array] A nested set of arrays with divert information for each type of divert currently set
  def get_diverts
    request = @browser.get("#{VoipfoneClient::API_GET_URL}?divertsMain")
    parse_response(request)["divertsMain"]
  end
end