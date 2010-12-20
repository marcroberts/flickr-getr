# Flickr-getr

Fetch all photos in a given set, updating the modified date after to match the 'date taken' from the flickr metadata.

It will not fetch files that already exist so it is safe to run periodically to keep the local copy up to date.

For windows users who don't want to install a complete ruby environment there is a compiled executable that is built using the ocra gem.

# TODO

* add error checking
* add pagination support for photosets with more than 500 photos

# changelog

## 0.1

* initial release