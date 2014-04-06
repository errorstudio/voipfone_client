class VoipfoneClient::Client
  # Return the balance of the account as a float.
  # == Returns::
  #   Balance as a float. Should be rounded to 2dp before presentation.     
  def account_balance
    request = @browser.get("#{VoipfoneClient::API_GET_URL}?balance&builder")
    parse_response(request)["balance"]
  end
end