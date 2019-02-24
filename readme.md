# OST Splitter


A command-line tool for splitting up Official Sound Tracks (OSTs). Perfect for movie soundtracks or concerts ripped from YouTube.

It takes practically any large audio file, and spits out a collection of tracks, cut, converted to `mp3 320kbps`, and with all their ID3 tags written.  

Requires a timestamp list - normally posted with the video, or found in the comments.

## Installation

* The Ruby runtime (`2.1` or later is fine)
* The audio command-line tool `ffmpeg`
* The ID3 library `taglib` (See [Installing taglib]())
* Several helper gems (run `install.sh` to install them)

> Please note:
The `taglib` library must be present before the gems are installed. (The `taglib-ruby` gem compiles against it)

## Usage

Minimal use case:

```bash
./ost_splitter -i <input-audio-file> -t <timestamp file> -o <output directory>
```

To populate the `ID3` tags, pass the optional `--album`, `--artist`, `--genre`, or `--year` flags.
```bash
./ost_splitter \
  -i <input-audio-file> \
  -t <timestamp file> \
  -o <output directory> \
  --album "404 Album Not Found" \
  --artist "Fred Rodriguez" \
  --year "1991" \
  --genre "Gunk" \
```

`ID3` track numbers will automatically be written.

### Detailed Usage

You will need:
* The source audio in any [audio format FFMPEG can handle](https://www.ffmpeg.org/general.html#toc-File-Formats).
* A text file containing the timestamp listing, in `00:00, Track Name` format

The format is: `<timestamp>, <track name>`, one per line.
The track name does not need to be quoted.
You may need to manually add the commas.

The timestamp reader is quite robust; it can handle anything from `12`, `2:43`, `00:32:01`, etc, and it correctly handles zeros. 

SMPTE timecode with frames count is not supported (Delete the frame segment and the rest will work fine)

> Please note:
The accuracy of the cut depends entirely on the accuracy of the timestamps. The timestamps must be in order.

## Appedix

### Installing FFMPEG

See the [official docs](https://ffmpeg.org/download.html).

### Installing TagLib

```
Debian/Ubuntu	sudo apt-get install libtag1-dev
Fedora/RHEL	sudo yum install taglib-devel
Homebrew	brew install taglib
MacPorts	sudo port install taglib

Windows users on Ruby 1.9 don't need that, because there is a pre-compiled binary gem available which bundles taglib.
```
See [TagLib-Ruby docs](http://robinst.github.io/taglib-ruby/) for more info.

## Contributing

The script is maintained by @AnalyzePlatypus. Pull requests welcome!

## License

MIT