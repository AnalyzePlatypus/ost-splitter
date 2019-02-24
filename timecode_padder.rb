#!/usr/bin/env ruby

class TimecodePadder
  def pad malformed_timestamp
    # puts "pad #{malformed_timestamp}"
    @padded = ""
    case malformed_timestamp.gsub(":", '').length
      when 0
        raise "Must be given a timestamp (at minimum an amount of seconds) (Got: #{malformed_timestamp})"
      when 1
        @padded = "00:00:0" + malformed_timestamp + ":00"
      when 2
        @padded = "00:00:" + malformed_timestamp + ":00"
      when 3
        @padded = "00:0" + malformed_timestamp + ":00"
      when 4
        @padded = "00:" + malformed_timestamp + ":00"
      when 5
        @padded = "0" + malformed_timestamp + ":00"
      when 6
        @padded = "" + malformed_timestamp + ":00"
      end
      return @padded
  end
end


=begin

require "minitest/autorun"
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

class TestMeme < Minitest::Test
  def setup
    @padder = TimecodePadder.new
  end

  def test_all
    assert_equal "00:00:00:00", @padder.pad("0")
    assert_equal "00:00:01:00", @padder.pad("1")
    assert_equal "00:00:42:00", @padder.pad("42")
    assert_equal "00:01:42:00", @padder.pad("1:42")
    assert_equal "00:11:42:00", @padder.pad("11:42")
    assert_equal "01:11:42:00", @padder.pad("1:11:42")
    assert_equal "11:11:42:00", @padder.pad("11:11:42")
  end
end

=end