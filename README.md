# fluent-plugin-debug

[![Build Status](https://secure.travis-ci.org/sonots/fluent-plugin-debug.png?branch=master)](http://travis-ci.org/sonots/fluent-plugin-debug)
[![Code Climate](https://codeclimate.com/github/sonots/fluent-plugin-debug.png)](https://codeclimate.com/github/sonots/fluent-plugin-debug)

Fluentd plugin to investigate incoming messages in a short-hand.

## Installation

Use RubyGems:

    gem install fluent-plugin-debug

## What is this for?

Do you use `out_copy` and `out_stdout` to see incoming messages?

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

This plugin enables to write the same thing in a short-hand, by just adding `debug true`, as:

```apache
<match **>
  type file
  debug true
  # blash blah
</match>
```

## Configuration

This plugin is doing something tricky, which extends arbitrary plugins so that they can use `debug` option parameter. 

```apache
<source>
  type debug # This makes available the `debug` option for all output plugins
</source>

<match **>
  type file
  debug true # Now you can use `debug true`
</match>
```

If you are lazy to write even `debug true`, you may use `debug_all` option. 

```apache
<source>
  type debug
  debug_all true # This makes turn on the `debug` option for all output plugins
</source>

<match **>
  type file # Now you don't need even to add `debug true`
</match>
```

## Options

### Options (source)

* debug_all

  * Apply `debug true` for all output plugins

### Options (output plugins)

This plugin extends all output plugins and enables to use the following options:

* debug (bool)

  * Enable to output the incoming messages

## ChangeLog

See [CHANGELOG.md](CHANGELOG.md) for details.

## Note

This plugin is dedicated to [@hirose31](https://github.com/hirose31). 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2014 Naotoshi Seo. See [LICENSE](LICENSE) for details.
