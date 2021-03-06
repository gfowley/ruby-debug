#!/usr/bin/env ruby
require File.expand_path("../helper", __FILE__)

# Test annotate handling.
class TestAnnotate < Test::Unit::TestCase
  include TestHelper

  def test_basic
    testname = 'annotate'
    script = File.join('data', testname + '.cmd')
    assert(run_debugger(testname, "--script #{script} -- ./example/gcd.rb 3 5"))
  end
end
