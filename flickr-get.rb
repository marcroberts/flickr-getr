#!/usr/bin/env ruby

# The MIT License (MIT)
#
# Copyright (c) 2013 Marc Roberts
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#
#
# flickr-getr
#
# version: 1.0.0


require 'rubygems'
require 'httparty'
require 'open-uri'
require 'tempfile' # for ocra

MultiJson.use :ok_json # ocra can't seem to vendor any other json lib

class Flickr
  include HTTParty
  base_uri 'api.flickr.com'
  format :json

  def initialize key
    @key = key
  end

  def photos set_id

    query = {
      :method => 'flickr.photosets.getPhotos',
      :api_key => @key,
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

if ARGV.count != 3
  print "Usage: flickr-get <apikey> <path> <photoset-id>\n"
  exit
end

ROOT = ARGV[1]
SET_ID = ARGV[2]

flickr = Flickr.new ARGV[0]

photos = flickr.photos(SET_ID)

photos['photoset']['photo'].each do |photo|
  filename = File.join(ROOT, "#{photo['id']}.#{photo['originalformat']}")
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