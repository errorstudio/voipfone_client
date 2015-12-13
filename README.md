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
* `extension_numbers()` returns an array of extension numbers associated with your account
* `phone_numbers()` returns an array of phone numbers associated with your account
* `voicemail()` gives you a list of your voicemails, but not (yet) the audio. Pull requests welcome!

```ruby

account = VoipfoneClient::Account.new 
account.balance   # => 123.4567890

```

### VoipfoneClient::Extension
The `VoipfoneClient::Extension` class has methods relating to your extensions:

* `all()` returns a collection of all extensions associated with your account
* `list()` returns a simple list of the extension numbers associated with your account


```ruby

VoipfoneClient::Extension.list # => ["200", "201", "202", "203", "204", "205", "206", ... ]

```

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

### VoipfoneClient::Report
The `VoipfoneClient::Report` class allows you to collect call report information for your account:

* `call_records_summary( call_type, date, range, extension_filter)` returns
  an an array of call summary data, namely duration, cost and number
  of calls per hour or day (depending on chosen range, see below)

* `call_records( call_type, date, range, extension_filter)` returns
  an an array of call record hashes containing call details, namely date
  and time, to, from, duration and cost

`call_type` is one of three __types__ in Voipfone, which we describe thus:

* `:outgoing` - for reporting on outgoing calls (this is the default)
* `:incoming` - for reporting on incoming calls
* `:missed` - for reporting on incoming calls that were not answered

`date` is a standard Ruby Date class, defaulting to today if not set.

`range` is either :month or :day, defaulting to :month

`extension_filter` is either the extension to report on, or :all for all extensions.  This is also the default.


``` ruby
include VoipfoneClient
r = VoipfoneClient::Report.call_records_summary( :missed, Date.today, :day, :all)
# => [{:duration=>0, :pkgMins=>0, :cost=>0.0, :calls=>0, :hour=>0}, {:duration=>0, :pkgMins=>0, :cost=>0.0, :calls=>0, :hour=>1}, ...]


```

Note that missed calls can have a duration if the caller left a voicemail message.


``` ruby
include VoipfoneClient
r = VoipfoneClient::Report.call_records( :outgoing, Date.today, :day, :all)
# => [{:datetime=>#<DateTime: 2015-12-11T19:37:00+00:00 ((2457368j,70620s,0n),+0s,2299161j)>, :from=>"30163517*200", :to=>"004412341234", :duration=>4, :cost=>"0.0120", :package_minutes=>"0"}, ...] 

```

Note that a search across all extensions for a month can take a while to download all the records.


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
