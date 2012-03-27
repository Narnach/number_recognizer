NumberRecognizer
================

NumberRecognizer is library to recognize mobile phone numbers. It can make educated guesses to correct local numbers into numbers in international format.

Examples
--------

    require "number_recognizer"
    @nc = NumberRecognizer.new("0612345678")
    @nc.valid_or_correct_mobile?  # => true
    @nc.country_name              # => "Netherlands"
    @nc.country                   # => "31"
    @nc.prefix                    # => "31"
    @nc.local_number              # => "612345678"
    @nc.normalized_number         # => "31612345678"

Supported countries
-------------------

It does not aim for worldwide coverage and correction, as that is not the problem I'm trying to solve.
If you want to add a country, feel free to send me a pull request or create a feature request.

* Australia (614xxxxxxxx)
* Belgium (324xxxxxxxx)
* England (447xxxxxxxx, 447xxxxxxxxx)
* Germany (491xxxxxxxxx, 491xxxxxxxxxx)
* Netherlands (316xxxxxxxx)
* Portugal (3519xxxxxxxx)
* Spain (346xxxxxxxx, 347xxxxxxxx)

Some countries have some number ranges not covered. The regular expressions cover those, so check [lib/number_recognizer.rb](http://github.com/Narnach/number_recognizer/blob/master/lib/number_recognizer.rb) for the details.

It is also possible to add your own custom format:

    NumberRecognizer.add_format :country => "Utopia", :mobile=>true, :format => /(99)(9\d{8})/, :country_code=>999
  
Installation
------------

Simply install the gem from rubygems:

    gem install number_recognizer
  
If you use Bundler, add it to your Gemfile and the do a bundle install:

    gem "number_recognizer"

Bug tracking / feature requests
-------------------------------

I use Github issues for this: https://github.com/Narnach/number_recognizer/issues

Disclaimer
----------

It scratches my own itch and does not aim to solve everyone's problems.
If it works for you, great! If it does not; fork it, patch it and send me a pull request.

Written by Wes 'Narnach' Oldenbeuving in 2009. Licensed under the MIT license.