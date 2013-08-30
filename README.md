      __|   __|  _ \  __|  __|   \ |   __|  |  |   _ \   _ \ __ __| __|  _ \
    \__ \  (       /  _|   _|   .  | \__ \  __ |  (   | (   |   |   _|     /
    ____/ \___| _|_\ ___| ___| _|\_| ____/ _| _| \___/ \___/   _|  ___| _|_\

# Screenshooter

A little web service that takes the URL of a web page and returns a URL to an
image of that page.

We use this to create PNGs of SVGs served by our Rails apps and to make
up-to-date images of Raphael graphics for sharing on Facebook and Twitter.

## Dependencies

  * [Sinatra](http://www.sinatrarb.com/)
  * [ImageMagick](http://www.imagemagick.org/script/index.php)
  * [PhantomJS](http://phantomjs.org/)

## Getting Started

Create `screenshooter.yml` from `screenshooter.sample.yml` and add your S3 credentials.

Start the server:

    ruby -rubygems screenshooter.rb

From any machine, shoot a URL:

    curl "http://localhost:4567/?url=http://tycho.usno.navy.mil/cgi-bin/timer.pl"
    curl "http://localhost:4567/?url=http://raphaeljs.com/tiger.html"

And the images show up at:

 * [http://bucketname.s3.amazonaws.com/screenshooter/tycho.usno.navy.mil/cgi-bin/timer.pl.png](http://assets.elections.huffingtonpost.com.s3.amazonaws.com/ss/tycho.usno.navy.mil/cgi-bin/timer.pl.png)
 * [http://bucketname.s3.amazonaws.com/screenshooter/raphaeljs.com/tiger.html.png](http://assets.elections.huffingtonpost.com.s3.amazonaws.com/ss/raphaeljs.com/tiger.html.png)

## Parameters

- `url`: The url you would like to generate an image from.
- `clip`: Area of the page to display. Consists of 4 integers (left, top, width, height) to be passed to
  [clipRect](https://github.com/ariya/phantomjs/wiki/API-Reference-WebPage#cliprect-object).
  - example: `0,0,1000,600`
- `resizewidth` and `resizeheight`: Resize the generated image to the specified
  size (via ImageMagick) before uploading. If only a width is supplied, the height is scaled proportionally.
- `hb`: Hashbang to add to the url.
  - example: `hb=#!smoothing=less`
- `callback`: Wrap the response in the specified function name for use with jsonp.

## Domain Filtering

By default, screenshooter can create images of urls on any domain. If you would like to whitelist
specific domains (useful for making sure nobody misuses your instance of screenshooter), add them to
screenshooter.yml. Entries are made in [Ruby regex format](http://rubular.com/).

## Authors

- Jay Boice, jay.boice@huffingtonpost.com
- Aaron Bycoffe, bycoffe@huffingtonpost.com
- Andrei Scheinkman, andrei@huffingtonpost.com

## Copyright

Copyright (c) 2012 The Huffington Post. See LICENSE for details.