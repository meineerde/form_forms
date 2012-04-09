# FormForms

Configurable forms for Rails 3, based on the excellent [simple_form](https://github.com/plataformatec/simple_form) gem.

The goal of this gem is to provide forms (as in views) which are flexible
enough to fullfill their intended usage but be able to be configured by
plugins. Thus plugins can easily add, delete and edit form fields without
having to override whole views which are hard to patch.

## Installation

Add this line to your application's Gemfile:

    gem 'form_forms'

and then run `bundle install`.

Or install it yourself using

    gem install form_forms

## Usage

TODO: Write usage instructions here. For now, see the tests.

## Development

[![Build Status](https://secure.travis-ci.org/meineerde/form_forms.png)](http://travis-ci.org/meineerde/form_forms)

Install dependencies with

    bundle install

then run tests with

    bundle exec rake

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
