require 'taglib';


filepath = "/Users/developer/workspace/ost_splitter/trimmed/1 My dear Frodo.mp3"

TagLib::FileRef.open(filepath) do |file|
  unless file.null?
    tag = file.tag
    puts tag.artist
    tag.title = "Phil"
    tag.album = "Phil's Stuff"
    tag.artist = "Phil"
    tag.genre = "Phil"
    tag.track = 42
    tag.year = 2018
    file.save
  end
end