# OR Tools on Rails

The goal of this project is to enable a [Ruby on Rails](https://rubyonrails.org/) application to access [Google OR Tools](https://developers.google.com/optimization) while deployed to [Heroku](https://heroku.com/). The project uses the [or-tools gem](https://github.com/ankane/or-tools) by [Andrew Kane](https://github.com/ankane).

## Geting started

1. Clone and run locally:


Per the [or-tools gem README](https://github.com/ankane/or-tools/blob/master/README.md), download the [OR-Tools C++ library](https://developers.google.com/optimization/install/cpp). Then run:

```
bundle config build.or-tools --with-or-tools-dir=/path/to/or-tools
```

Clone this repo:
```
git clone git@github.com:pony-deluxe/or-tools-on-rails.git
cd or-tools-on-rails
bundle install
```
(or create a new Rails app and `bundle add or-tools`)

Create a new heroku application and add OR Tools via a [buildpack](https://github.com/pony-deluxe/heroku-ortools-buildpack) (very WIP)
```
heroku create my-new-app
heroku buildpacks:add --index 1 https://github.com/pony-deluxe/heroku-ortools-buildpack.git
```

Tell Heroku to build the or-tools gem with the OR Tools binary:
```
heroku config:set BUNDLE_BUILD__OR_TOOLS=/app/or-tools/or-tools_Ubuntu-18.04-64bit_v7.6.7691
```

Push to Heroku:
```
git push heroku master
```

Currently `or-tools` fails to install properly, causing the deploy to fail.

Currently `or-tools` gem fails to install, causing the deploy to be rejected.
