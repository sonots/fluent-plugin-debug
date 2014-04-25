# fluent-plugin-debug

[![Build Status](https://secure.travis-ci.org/sonots/fluent-plugin-debug.png?branch=master)](http://travis-ci.org/sonots/fluent-plugin-debug)
[![Code Climate](https://codeclimate.com/github/sonots/fluent-plugin-debug.png)](https://codeclimate.com/github/sonots/fluent-plugin-debug)

Fluentd plugin to output incoming messages without `<store></store>` directives.

## Installation

Use RubyGems:

    gem install fluent-plugin-debug

## What is this for?

You use `out_copy` and `out_stdout` to see incoming messages?

```apache
<match **>
  type copy
  <store>
    type stdout
  </store>
  <store>
    type file
    # blah blah
  </store>
</match>
```

This plugin enables to write the same thing in short hand as:

```apache
<match **>
  type file
  debug true
  # blash blah
</match>
```

What you have to do is just adding `debug true`. 

## Configuration

This plugin is doing something tricky, which extends arbitrary plugins so that they can use `debug` option parameter. 

```apache
<source>
  type debug
  # This makes available the `debug` parameter for all output plugins
</source>

<match **>
  type file
  debug true # Now you can use `debug true`
</match>
```

## ChangeLog

See [CHANGELOG.md](CHANGELOG.md) for details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2014 Naotoshi Seo. See [LICENSE](LICENSE) for details.
