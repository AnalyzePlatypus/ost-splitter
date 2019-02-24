#!/usr/bin/env ruby

require 'taglib';
require 'colorize'
require 'awesome_print'
require 'slop'

require_relative "./parser.rb"

VERSION = "1.0"

opts = Slop.parse do |o|
  o.string '-i', '--input-audio', 'an audio file to split', required: true
  o.string '-t', '--timestamp-file', 'a text file containing the timestamps', required: true
  o.string '-o', '--output-dir', 'a directory for the generated files', required: true
  o.string '--album', 'the album name to embed in the id3 tags', default: ""
  o.string '--artist', 'the artist name to embed in the id3 tags', default: ""
  o.string '--year', 'the year to embed in the id3 tags', default: ""
  o.string '--genre', 'genre name to embed in the id3 tags', default: ""
  o.on '--version', 'print the version' do
    puts VERSION
    exit
  end
end


TIMESTAMP_FILE_PATH = opts['timestamp-file']
INPUT_FILE = opts['input-audio']
OUTPUT_DIR = opts['output-dir']

ALBUM = opts['album']
ARTIST = opts['artist']
YEAR = opts['year'].to_i
GENRE = opts['genre']

# Runtime

puts "\nOST Splitter v0.1\n".yellow
puts "Splitting file: ".blue + INPUT_FILE.green
puts "Based on timestamp file: ".blue + TIMESTAMP_FILE_PATH.green
puts "Outputting files to: ".blue + OUTPUT_DIR.green
puts "\n"

print "🌀  Generating timestamps...".blue
timestamps = TimestampParser.new.file_to_timestamp_list(TIMESTAMP_FILE_PATH)
puts " Done\n".green

timestamps[0..-1].each_with_index do |ts, i|
  puts "#{i + 1}/#{timestamps.length} #{ts[:track_title]}".yellow
  ap ts # Debug: prints timestamp details
  
  output_filename = "#{OUTPUT_DIR}/#{ts[:track_number]} #{ts[:track_title]}.mp3"
  
  puts "🌀  Trimming and converting to mp3...".blue
  cmd = "ffmpeg \
    -loglevel quiet -n \
    \
    -ss \"#{ts[:start_at]}\"\
    -i  \"#{INPUT_FILE}\" \
    \
    -t \"#{ts[:duration]}\"\
    -vn \
    -f mp3 \
    -ab 320000 \
    \"#{output_filename}\""
  
  # puts cmd
  
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