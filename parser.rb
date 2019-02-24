#!/usr/bin/env ruby

require 'awesome_print'
require 'timecode'
require_relative 'timecode_padder'

TIMESTAMP_FILE_PATH = '/Users/developer/workspace/ost_splitter/timestamps.txt'

FULL_FILE_LENGTH = '2:21:16' 

TIMECODE_ONE_SECOND = Timecode.parse("00:00:01:00", fps = 30)

def convert_to_timecode timestamp
  # puts "convert_to_timecode `#{timestamp}`"
  padded = @padder.pad timestamp
  Timecode.parse padded, fps = 30
end


def strip_frame_segment timecode 
  timecode[0..-4]
end


class TimestampParser
  def file_to_timestamp_list(file)
    file_contents = File.open(file).read
    @lines = file_contents.split("\n")
    @timestamps = []
    extract_timestamps
    @timestamps
  end

  def extract_timestamps
    @padder = TimecodePadder.new
    @lines.each_with_index do |line, current_track|
      columns = line.split(', ')
      track_info = {
        track_number: (current_track + 1),
        start_at: strip_frame_segment(@padder.pad(columns[0])),
        end_at: strip_frame_segment(get_track_end(current_track)),
        track_title: columns[1]
      }
      track_info[:duration] = strip_frame_segment (convert_to_timecode(track_info[:end_at]) - convert_to_timecode(track_info[:start_at])).to_s
      @timestamps.push track_info
    end
  end

  def get_track_end(current_track_index)

    next_track_start = is_last_track?(current_track_index) ?
      FULL_FILE_LENGTH : 
      get_next_track_start_time(current_track_index)
    
    next_track_start_timecode = convert_to_timecode next_track_start

    this_track_end_timecode = (next_track_start_timecode - TIMECODE_ONE_SECOND).to_s
  end

  def is_last_track?(current_track_index)
    @lines[current_track_index + 1].nil?
  end

  def get_next_track_start_time current_track_index
    @lines[current_track_index + 1].split(',')[0]
  end
end

# timestamps = TimestampParser.new.file_to_timestamp_list TIMESTAMP_FILE_PATH


# ap timestamps[0..10]
