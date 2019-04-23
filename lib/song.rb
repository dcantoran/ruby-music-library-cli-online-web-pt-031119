require 'pry'
class Song 
  extend Concerns::Findable
  attr_accessor :name
  attr_reader :artist, :genre
  @@all = []
  
  def initialize(name, artist = nil, genre = nil)
    @name = name 
    self.artist = artist if artist
    self.genre = genre if genre
  end 
  
  def genre=(genre)
    @genre = genre 
    genre.songs << self unless genre.songs.include?(self)
  end 
  
  def self.all 
    @@all
  end 
  
  def self.destroy_all
    @@all.clear
  end 
  
  def save 
    @@all << self
  end 
  
  def self.create(song)
    song = self.new(song)
    song.save
    song
  end 
  
  def artist=(artist)
    @artist = artist 
    artist.add_song(self)
  end 
  
  def self.find_by_name(name)
    all.find {|song| song.name == name}
  end 
  
  def self.find_or_create_by_name(name)
    find_by_name(name) || create(name)
  end 
  
  def self.new_from_filename(filename)
    artist_name, song_name, genre_name = filename.chomp(".mp3").split(" - ")
    artist = Artist.find_or_create_by_name(artist_name)
    genre = Genre.find_or_create_by_name(genre_name)
    Song.new(song_name, artist, genre)
  end 
  
  def self.create_from_filename(song)
    self.new_from_filename(song).save
  end 
  
end 