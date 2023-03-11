# Bridgetown deploy hook plugin

A [Bridgetown](https://www.bridgetownrb.com) plugin for triggering behavior via a webhook.

## Installation

Run this command to add this plugin to your site's Gemfile:

    bundle add bridgetown-deploy_hook

Or you can use [an automation script](https://www.bridgetownrb.com/docs/automations) instead for guided setup:

    bin/bt apply https://github.com/michaelherold/bridgetown-deploy_hook

## Usage

To use a post-deploy hook, you must run Bridgetown with the Roda app; a static website will not work. First, add the Roda plugin to your app and call the helper for enabling the route:

```ruby
# server/roda_app.rb
class RodaApp < Bridgetown::Rack::Roda
  plugin :bridgetown_ssr
  plugin :bridgetown_deploy_hook
  
  route do |r|
    r.bridgetown_deploy_hook
  end
end
```

Note that you must enable the plugin _after_ the `:bridgetown_ssr` plugin because the latter is what sets up your Bridgetown site for use by the Roda app.

Next, configure your route and authorization methods using the initializer. For example, if you want `/my-deploy-hook` to be the route for your hook and use a static [Bearer token](https://datatracker.ietf.org/doc/html/rfc6750) from your environment variables as an authorization mechanism:

```ruby
# config/initializers.rb

Bridgetown.configure do
  init(
    "bridgetown-deploy_hook",
    authorization: {
      bearer: ->(token) { token == ENV["BEARER_TOKEN"] }
    }
    route: "my-deploy-hook"
  )
end
```

Lastly, register the action that you want to run with the deploy hook:

```ruby
# config/initializers.rb
# ... or any other auto-loaded file in your app
Bridgetown::Hooks.register_one :site, :post_deploy do |site|
  # Your code here
end
```

`site` is your `Bridgetown::Site` instance so you have access to all of your configuration and resources that you have configured.

### Authorization

You may register anything that responds to `#call`, takes a string argument of the directives for your authorization type, and responds with a truthy value when authorization succeeds.

Each [authorization scheme](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication#authentication_schemes) may have a single handler registered to it. Register them with either the symbol or string cooresponding to the lowercase version of the scheme. For example, if you want to register both a [Basic](https://datatracker.ietf.org/doc/html/rfc7617) handler and a [Bearer](https://datatracker.ietf.org/doc/html/rfc6750) handler, that would look like the following:

```ruby
# config/initializers.rb

Bridgetown.configure do
  init(
    "bridgetown-deploy_hook",
    authorization: {
      basic: my_basic_handler,
      bearer: my_bearer_handler,
    }
    route: "my-deploy-hook"
  )
end
```

The **handlers receive the raw value from the header**, not a destructured version. So the Basic handler receives the Base64-encoded `user:password` pair, not the user and the password, so you must handle the parsing of the value appropriately for the authorization scheme.

### Plugin authors

Plugins may also interact with the deploy hook by registering their own [non-reloadable](https://www.bridgetownrb.com/docs/plugins/hooks#reloadable-vs-non-reloadable-hooks) hook handlers.

As an example:

```ruby
Bridgetown::Hooks.register_one :site, :post_deploy, reloadable: false do |site|
  MyPlugin.do_the_work(site)
end
```

## Contributing

So you're interested in contributing to Bridgetown deploy hook? Check out our [contributing guidelines](CONTRIBUTING.md) for more information on how to do that.
