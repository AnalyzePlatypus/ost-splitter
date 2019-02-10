# OST Splitter


A command-line tool for splitting up Official Sound Tracks (OSTs). Perfect for movie soundtracks or concerts ripped from YouTube.

It takes practically any large audio file, and spits out a collection of tracks, cut, converted to `mp3 320kbps`, and with all their ID3 tags written.  

(Requires a timestamp list - normally posted with the video, or found in the comments) 
(The accuracy of the cut depends entirely on the accuracy of the timestamps. The timestamps must also be in order)

## Installation

* The Ruby runtime (`2.1` or later is fine)
* The audio command-line tool `ffmpeg`
* The ID3 library `taglib` (`brew install taglib`)
* Several helper gems (run `install.sh` to install them)

## Usage

### TL;DR

1. Collect your timestamps in a text file, (light formating by hand may be necessery)
2. Point several constants in the code at your source files.
3. `./ost_splitter`

### Detailed Usage

You will need:
* The source audio in any [audio format FFMPEG can handle](https://www.ffmpeg.org/general.html#toc-File-Formats).
* A text file containing the timestamp listing, in `00:00, Track Name` format

The format is: `<timestamp>, <track name>`, one per line.
The track name does not need to be quoted.
You may need to manually add the commas.

The timestamp reader is quite robust; it can handle anything from `12`, `2:43`, `00:32:01`, etc, and it correctly handles zeros. 

SMPTE timecode with frames count is not supported (Delete the frame segment and the rest will work fine)

### To run:

In `split_ost`:
1. Set the `INPUT_FILE` to the path to your full-length source OST audio file
2. You may want to set the `ALBUM`, `ARTIST`, `GENRE`, and `YEAR` constants. These will be copied into the ID3 tags.

In `parser.rb`:

3. Set the `FULL_FILE_LENGTH` constant in `parser.rb` to the length of the file (this is used for generating the closing timestamp for the final track)

Other:

4. You might want to empty the `trimmed` directory from the results of the past run.

5. Run `./split_ost`

That should do it!

Output file are placed in `<source code dir>/trimmed/`.



