class VoipfoneClient::Client
  #Return a list of voicemail entries, with details for each
  #@return [Hash] of voicemail information. This includes a reference to a WAV file which isn't accessible (yet?)
  def voicemail
    request = @browser.get("#{VoipfoneClient::API_GET_URL}?vm_view")
    parse_response(request)["vm_view"].first["voicemail"]
  end
end