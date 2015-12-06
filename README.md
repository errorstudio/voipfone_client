# Voipfone Client

A gem to programatically manipulate your [Voipfone](http://www.voipfone.co.uk) account using Ruby.

Voipfone is a brilliant SIP VOIP provider with a very neat set of features, but unfortunately no API. So this gem hopefully fills that gap by using the same JSON API their web interface uses.

## A quick note about using your account balance
This is rather obvious, but let's say it anyway! This client uses your Voipfone account. Sending SMS messages, setting diverts, setting up calls and other functions will use up your account balance! We're not magically doing stuff for free here.

[Here's a page about Voipfone's charges](https://www.voipfone.co.uk/prices_new.php). We think they're very good value.

## Installation

This gem is in Rubygems, so you can add this line to your application's Gemfile:

    gem 'voipfone_client'

And then execute:

    $ bundle

Or you can manually install the gem using:

	gem install voipfone_client

##Configuration and Use

Before you can use the gem you need to configure it:

```ruby
VoipfoneClient.configure do |config|
	config.username = "your@email.address"
	config.password = "yourpass"
	config.user_agent_string = "something" #default is set to "VoipfoneClient/[version] http://github.com/errorstudio/voipfone_client" in voipfone_client.rb
end
```

This approach gives us lots of options for adding more config options in the future.

After you've done that, there are various classes which you can use to access different parts of your Voipfone Account.

### VoipfoneClient::Account
The `VoipfoneClient::Account` class has methods relating to your account:

* `balance()` returns your balance as a float
* `details` returns a hash of your account details (email, name etc)
* `phone numbers()` returns an array of phone numbers associated with your account
* `voicemail()` gives you a list of your voicemails, but not (yet) the audio. Pull requests welcome!

### VoipfoneClient::RegisteredMobile
The `VoipfoneClient::RegisteredMobile` class only has one class method at the moment, `VoipfoneClient::RegisteredMobile.all()` which returns an array of `VoipfoneClient::RegisteredMobile` objects. These respond to `number()` and `name()`.

These are particularly useful to know for sending SMS messages, because the 'from' number has to be in this list. You can't send an SMS from an arbitrary number.

```ruby

include VoipfoneClient
mobiles = RegisteredMobile.all #this will be an array
m = mobiles.first
m.name #this will be the name of the mobile
m.number #this will be the number of the mobile

```

### VoipfoneClient::SMS
The `VoipfoneClient::SMS` class allows you to send SMS messages from your account.

You need to make sure that you're sending _from_ a number which is in the list of registered mobiles.

``` ruby
include VoipfoneClient
s = SMS.new
s.from = "[sender number]" # a number which is in the list of registered mobiles at voipfone
s.to = "[recipient number]" #your recipient number
s.message = "your message" #message is truncated at 160 chars; UTF-8 not supported.

```

Spaces are stripped from phone numbers (which need to be supplied as a string); international format with a + symbol is OK.

### VoipfoneClient::GlobalDivert
The `VoipfoneClient::GlobalDivert` class handles diverts for your whole account (all extensions).

Diverts are one of four __types__ in Voipfone, which we describe thus:

* `:all` - divert all the time
* `:fail` - divert when something's gone wrong with your VOIP equipment
* `:busy` - divert when all lines are busy
* `:noanswer` - divert when there's no answer on any line (we haven't experimented about the relationship between this and voicemail)

You can get a list of all the diverts on your account with the `Voipfone::GlobalDivert.all()` class method, which returns an array of diverts, each with their type and number.

To create a divert, you need to set a __type__ and a __number__:

```ruby

include VoipfoneClient
d = GlobalDivert.new
d.type = :all # divert for all calls - e.g. your whole team is out of the office; our most common use-case
d.number = "your number as a strong" # this can be any phone number
d.save # will return true on success

```
In the Voipfone web interface you have to set up a list of divert recipients (and you can do that in this client too), but you don't _need_ to - you can set any number for a divert. As with all other numbers you set, it should be passed in as a string, spaces will be stripped, the + symbol is allowed.

##To Do

There's quite a list of stuff which would be nice to do. If you feel inclined, we'd love pull requests.

* Find a way to get the audio for voicemails
* per-extension diverts
* Setting up calls
* Downloading call records
* Downloading invoices


## Contributing

We'd love your input!

1. Fork the repo ( http://github.com/errorstudio/voipfone_client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
