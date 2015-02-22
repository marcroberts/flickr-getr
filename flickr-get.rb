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
# version: 2.0.0

require 'rubygems'
require 'bundler'
require 'open-uri'
require 'tempfile'
require 'byebug'
require './task'

Bundler.require

# MultiJson.use :ok_json # ocra can't seem to vendor any other json lib

# class Flickr
#   include HTTParty
#   base_uri 'https://api.flickr.com'
#   format :json

#   def initialize key
#     @key = key
#   end

#   def photos set_id

#     query = {
#       :method => 'flickr.photosets.getPhotos',
#       :api_key => @key,
#       :photoset_id => set_id,
#       :per_page => 500,
#       :extras => 'date_taken,original_format',
#       :media => 'photo',
#       :format => 'json',
#       :nojsoncallback => 1
#     }

#     self.class.get('/services/rest/', :query => query, :verify => false)
#   end

# end






begin
  if ARGV.count == 3 && ARGV[0] == 'auth'

    FlickRaw.api_key=ARGV[1]
    FlickRaw.shared_secret=ARGV[2]

    token = flickr.get_request_token
    auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')

    puts "Open this url in your browser to complete the authication process : #{auth_url}"
    puts "Enter the number given when you complete the process."
    verify = STDIN.gets.strip

    flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
    login = flickr.test.login
    puts "You are now authenticated as #{login.username}\n\n"
    puts "Creating config.yml.. "

    new_config = YAML.load(open('config.example.yml'))
    new_config['api']['key'] = ARGV[1]
    new_config['api']['secret'] = ARGV[2]
    new_config['oauth']['token'] = flickr.access_token
    new_config['oauth']['secret'] = flickr.access_secret

    File.open('config.yml', 'w') do |file|
      file.write YAML.dump(new_config)
    end
  end

  config = YAML.load(open('config.yml'))

  FlickRaw.api_key=config['api']['key']
  FlickRaw.shared_secret=config['api']['secret']

  raise StandardError("API Key is missing") if config['api']['key'].empty?
  raise StandardError("API Secret is missing") if config['api']['secret'].empty?

rescue StandardError => e

  print "Error parsing config:\n\n"
  print e.message
  print e.backtrace
  print "\n\nMaybe you need to run '#{$0} auth <API KEY> <API SECRET>' first?\n\n"
  exit
end



config['tasks'].each do |task|
  Task.new(config, task).run
end

exit


photos = flickr.photos(SET_ID)

photos['photoset']['photo'].each do |photo|


end
