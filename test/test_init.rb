require 'test/unit'

require 'rubygems'
require 'bundler/setup'

require 'shoulda'


def deny(expected, msg = '')
  assert !expected, msg
end