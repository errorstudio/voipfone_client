class VoipfoneClient::Client
  def voicemail
    request = @browser.get("#{VoipfoneClient::API_GET_URL}?vm_view")
    parse_response(request)["vm_view"].first["voicemail"]
  end
end