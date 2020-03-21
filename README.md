# RailsSameSiteCookie

This gem sets the SameSite=None directive on all cookies coming from your Rails app that are missing the SameSite directive. This behavior can also be limited to only requests coming from a specific user agent.

This is useful because in February 2020 Chrome will start treating any cookies without the SameSite directive set as though they are SameSite=Lax(https://www.chromestatus.com/feature/5088147346030592). This is a breaking change from the previous default behavior which was to treat those cookies as SameSite=None. See [this explanation](https://web.dev/samesite-cookies-explained/) for more information on the SameSite directive and the reasons for this change.

This new behavior shouldn't be a problem for most apps but if your Rails app provides an API that uses cookies for authentication (which itself may or may not be ill-advised), the new behavior means cookie authenticated requests to your API from third-party domains will no longer work in Chrome. In addition, fixing the problem isn't as simple as just setting SameSite=None on your app's cookies because there are a number of user agents that will either (a) ignore cookies with SameSite=None or (b) treat SameSite=None as SameSite=Strict. In other words, if a cookie-authenticated API sets SameSite=None it will break for some users, and if it doesn't set SameSite=None, it will also break for many users.

This gem fixes the above problems by explicity setting SameSite=None for all cookies where the SameSite directive is missing and the requesting user agent is not in Chrome's [provided list of known incompatible clients](https://www.chromium.org/updates/same-site/incompatible-clients).

### Note about HTTP requests and local testing
Note that for Chrome/Chromium based browsers the gem only sets the SameSite flag on cookies sent over HTTPS. So if you're testing on your local machine and you haven't setup your localhost to use SSL you will see warnings in versions of Chrome less than 80 about the missing SameSite flag, and in Chrome 80+ these cookies will be ignored entirely. To work around this in Chrome 80+ without setting up SSL you can disable the following Chrome flags: chrome://flags/ -> `SameSite by default cookies` and `Cookies without SameSite must be secure`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_same_site_cookie'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_same_site_cookie

## Usage

Once you've installed the gem that's basically it unless you want to limit the SameSite=None behavior to specific user agents. This can be useful, for example, if you have a cordova app (or other client) that accesses your API using a custom user agent string and you know in those situations that the cookie will not be accessible to third party sites because the containing browser will never be allowed to navigate to other domains.

To set this up:
```ruby
#config/initializers/rails_same_site_cookie.rb
RailsSameSiteCookie.configure do |config|
  config.user_agent_regex = /MyCustomUserAgentString/
end
```

Now only user agents that support SameSite=None and match the given regex string will have the directive set.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rails_same_site_cookie. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RailsSameSiteCookie project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rails_same_site_cookie/blob/master/CODE_OF_CONDUCT.md).
