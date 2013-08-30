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

Create <code>screenshooter.yml</code> from <code>screenshooter.sample.yml</code> and add your S3
credentials.


Start the server:

    ruby -rubygems screenshooter.rb


From any machine, shoot a URL:

    curl "http://localhost:4567/?url=http://tycho.usno.navy.mil/cgi-bin/timer.pl"
    curl "http://localhost:4567/?url=http://raphaeljs.com/tiger.html&width=200&height=200"

And the images show up at:

 * [http://bucketname.s3.amazonaws.com/screenshooter/tycho.usno.navy.mil/cgi-bin/timer.pl.png](http://assets.elections.huffingtonpost.com.s3.amazonaws.com/ss/tycho.usno.navy.mil/cgi-bin/timer.pl.png)
 * [http://bucketname.s3.amazonaws.com/screenshooter/raphaeljs.com/tiger.html.png](http://assets.elections.huffingtonpost.com/ss/raphaeljs.com/tiger.html.png)

## Authors

- Jay Boice, jay.boice@huffingtonpost.com
- Aaron Bycoffe, bycoffe@huffingtonpost.com
- Andrei Scheinkman, andrei@huffingtonpost.com

## Copyright

Copyright (c) 2012 The Huffington Post. See LICENSE for details.