# Flickr-getr

Fetch all photos in a given set, updating the modified date after to match the 'date taken' from the flickr metadata.

It will not fetch files that already exist so it is safe to run periodically to keep the local copy up to date.

For windows users who don't want to install a complete ruby environment there is a compiled executable that is built using the ocra gem available in the [releases section](https://github.com/marcroberts/flickr-getr/releases).

You will need to sign up for a flickr API key (it's free).

# Usage

    ruby flickr-getr.rb <apikey> <target-folder> <photoset-id>

# TODO

* add error checking
* add pagination support for photosets with more than 500 photos
