#!/usr/bin/env ruby

require 'taglib';
require 'colorize'
require 'awesome_print'

require_relative "./parser.rb"

INPUT_FILE = "/Users/developer/workspace/ost_splitter/The Hobbit - an Unexpected Journey Full Soundtrack (with Bonus Tracks) - By Howard Shore-JfEcgke5WCg.opus.wav".freeze
OUTPUT_DIR = "/Users/developer/workspace/ost_splitter/trimmed"
TIMESTAMP_FILE_PATH = '/Users/developer/workspace/ost_splitter/timestamps.txt'

ALBUM = "The Hobbit: an Unexpected Journey Full Soundtrack"
ARTIST = "Howard Shord"
YEAR = 2012
GENRE = "Soundtrack"


puts "\nOST Splitter v0.1\n".yellow
puts "\nSplitting file: ".blue + INPUT_FILE.green
puts "Outputting files to: ".blue + OUTPUT_DIR.green

puts "\n🌀  Generating timestamps...".blue
timestamps = TimestampParser.new.file_to_timestamp_list(TIMESTAMP_FILE_PATH)
puts '✅ Done'.green

timestamps[0..-1].each_with_index do |ts, i|
  puts "#{i + 1}/#{timestamps.length} #{ts[:track_title]}".yellow
  ap ts # Debug: prints timestamp details
  
  output_filename = "#{OUTPUT_DIR}/#{ts[:track_number]} #{ts[:track_title]}.mp3"
  
  puts "🌀  Trimming and converting to mp3...".blue
  cmd = "ffmpeg \
    -loglevel error -n \
    -i  \"#{INPUT_FILE}\" \
    -ss \"#{ts[:start_at]}\"\
    -to \"#{ts[:end_at]}\"\
    -vn \
    -f mp3 \
    -ab 320000 \
    \"#{output_filename}\""
  `#{cmd}`
  
  puts "🌀  Writing ID3 tags...".blue
  TagLib::FileRef.open(output_filename) do |file|
    unless file.null?
      tag = file.tag
      tag.track = ts[:track_number]
      tag.title = ts[:track_title]
      tag.album = ALBUM
      tag.artist = ARTIST
      tag.genre = GENRE
      tag.year = YEAR
      file.save
    end
  end
  puts "✅  Tags written.".green

  puts "✅  Track Completed.\n".green
end

puts "✅  Script Completed.\n".green
puts "You can find your completed files in: ".blue + OUTPUT_DIR.green