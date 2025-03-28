[![Build Status](https://travis-ci.org/tedconf/front_end_builds.svg)](https://travis-ci.org/tedconf/front_end_builds) [![Code
Climate](https://codeclimate.com/github/tedconf/front_end_builds/badges/gpa.svg)](https://codeclimate.com/github/tedconf/front_end_builds) [![Gem Version](https://badge.fury.io/rb/front_end_builds.svg)](http://badge.fury.io/rb/front_end_builds)

# FrontEndBuilds

Front-End Builds (FEB) lets you easily serve remotely-hosted static (JS) applications from your Rails apps. For example, you can host a Rails backend on Heroku, an Ember.js frontend on S3, and use FEB to connect the two.

![](https://camo.githubusercontent.com/175c23176da269c03c5d3f51a8feef3bdb50fc8a/687474703a2f2f63762d73637265656e73686f74732e73332e616d617a6f6e6177732e636f6d2f41646d696e5f323031352d30332d31305f30302d35312d32352e706e67)

![](https://camo.githubusercontent.com/979b56c0651251f4cf428ff354990ee167aeaf63/687474703a2f2f63762d73637265656e73686f74732e73332e616d617a6f6e6177732e636f6d2f41646d696e5f323031352d30332d31305f30302d35302d35382e706e67)

Benefits:
  - JS app can be deployed without redeploying your Rails app
  - Easily smoke test SHAs, branches and releases in your production environment with query params:
    http://your-app.com/my-ember-app?branch=new-feature

Features:
  - Admin interface lets you easily view, rollback and activate different app versions

The motivation for this gem came from [Luke Melia's RailsConf2014 talk](http://www.confreaks.com/videos/3324-railsconf-lightning-fast-deployment-of-your-rails-backed-javascript-app).


## Installation

Add this line to your application's Gemfile:

```
gem 'front_end_builds'
```

And then execute:

```
$ bundle
```

Front-End Builds brings some migrations along with it. To run, execute

```
rake front_end_builds:install:migrations
rake db:migrate
```

## Usage

First, mount the admin interface in `routes.rb`:

```rb
Rails.application.routes.draw do

  mount FrontEndBuilds::Engine, at: '/frontends'

end
```

You should mount this under an authenticated route using your application's
auth strategy, as anyone with access to the admin will be able to affect the
production builds of your front end apps.a

If you don't want to set up an HTML auth strategy, you can do something like this:

```rb
# routes.rb
protected_app = Rack::Auth::Basic.new(FrontEndBuilds::Engine) do |username, password|
  username == 'admin' && password == (Rails.env.production? ? ENV['FEB_ADMIN_PASSWORD'] : '')
end
mount protected_app, at: '/frontends'
```

This will use basic HTTP auth to secure access to your admin ui. Just set the ENV variable in production, and use it to gain access. If you're deploying to Heroku, use [Config Vars](https://devcenter.heroku.com/articles/config-vars).

Now, to create a new app, first add a `front_end` route pointing to your app in `routes.rb`:

```rb
Rails.application.routes.draw do

  front_end 'app-name', '/app-route'

end
```

Visit the admin (at whatever URL you mounted the engine above), create a
new app named `app-name`, and you'll receive  instructions on how to
start pushing builds.

Note:
If you're using this engine to serve an ember app at the Root, be sure to put all other Rails routes above the `front_end` route - as this takes priority over all routes below it!

```rb
Rails.application.routes.draw do
  # All other Rails routes here

  front_end 'app-name', '/'
end
```

## Configurations Options

Should you wish to allow deploys from an approved branch only, you may set the following environment variables

`FRONT_END_BUILDS_RESTRICT_DEPLOYS=TRUE` and set the approved branch `FRONT_END_BUILDS_PRODUCTION_BRANCH=the_name_of_your_approved_branch`

This can be troublesome if you're deploying from TravisCI as builds are always tagged `HEAD`, you can resolve this by adjusting your `.travis.yml`.

```yml
install:
- git checkout ${TRAVIS_BRANCH}
```

This basically just ensures that the branch name is available to `ember-cli-front-end-builds` to tag the deploy.


## Development

**Admin**

The Admin interface is an Ember CLI app within feb. A distribution is kept
within the gem, and must be updated whenever admin code is updated.

After changing the admin app, run

```
rake admin:build
```

to store a fresh distribution.

**Running tests**

```
# Rails tests
rspec

# Admin tests, from /admin dir
ember test
```

## Build status
This gem is built on Travis-CI.

![](https://travis-ci.org/tedconf/front_end_builds.svg?branch=master)

## TODO

* Create docs site
* Auto live setting
* make posts idempotent (i think they are), but dont insert a new row if
  it already exists.
