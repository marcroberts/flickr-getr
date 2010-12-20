#!/usr/bin/env ruby

# flickr-getr
#
# version: 0.1

require 'rubygems'
require 'httparty'
require 'open-uri'
require 'tempfile' # for ocra

class Flickr
  include HTTParty
  base_uri 'api.flickr.com'
  format :json
  
  
  def photos set_id
    
    query = {
      :method => 'flickr.photosets.getPhotos',
      :api_key => 'cedccf118bf9c2395a8f40005ad59c57',
      :photoset_id => set_id,
      :per_page => 500,
      :extras => 'date_taken,original_format',
      :media => 'photo',
      :format => 'json',
      :nojsoncallback => 1
    }
    
    self.class.get('/services/rest/', :query => query)
  end
  
end

# ----------------

if ARGV.count != 2
  print "Usage: flickr-get <path> <photoset-id>"
  exit
end

ROOT = ARGV[0]
SET_ID = ARGV[1]

flickr = Flickr.new

photos = flickr.photos(SET_ID)

photos['photoset']['photo'].each do |photo|
  filename = File.join(ROOT, "#{photo['id']}.jpg")
  unless File.exist?(filename)
    
    url = "http://farm#{photo['farm']}.static.flickr.com/#{photo['server']}/#{photo['id']}_#{photo['originalsecret']}_o.#{photo['originalformat']}\n"
    date = Time.parse(photo['datetaken'])
    
    File.open(filename, 'w') do |file|
      file.binmode
      file.write(open(url).read)
    end
    
    File.utime(date, date, filename)
    
  end
  
end