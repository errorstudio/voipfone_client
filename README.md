# Voipfone Client

A gem to programatically manipulate your [Voipfone](http://www.voipfone.co.uk) account using Ruby.

Voipfone is a brilliant SIP VOIP provider with a very neat set of features, but unfortunately no API. So this gem hopefully fills that gap by using the same JSON API their web interface uses.

## Installation

This gem is in Rubygems, so you can add this line to your application's Gemfile:

    gem 'voipfone_client'

And then execute:

    $ bundle

Or you can manually install the gem using:

	gem install voipfone_client

##Configuration and Use

Before you can instantiate a `VoipfoneClient::Client` object, you need to need to configure it:

```ruby
VoipfoneClient.configure do |config|
	config.username = "your@email.address"
	config.password = "yourpass"
end
```

This approach gives us lots of options for adding more config options in the future.

After that you can create a new object to call Voipfone:

```ruby
c = VoipfoneClient::Client.new
c.account_balance #will return your balance as a float
```

## Contributing

We'd love your input!

1. Fork it ( http://github.com/errorstudio/voipfone_client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
