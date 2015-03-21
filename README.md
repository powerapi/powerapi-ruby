[![Build Status](https://img.shields.io/travis/powerapi/powerapi-ruby.svg?style=flat-square&branch=master)](https://travis-ci.org/powerapi/powerapi-ruby)
[![Coverage Status](https://img.shields.io/coveralls/powerapi/powerapi-ruby.svg?style=flat-square)](https://coveralls.io/r/powerapi/powerapi-ruby)
[![Code Climate](http://img.shields.io/codeclimate/github/powerapi/powerapi-ruby.svg?style=flat-square)](https://codeclimate.com/github/powerapi/powerapi-ruby)
[![Gem Version](https://img.shields.io/gem/v/powerapi.svg?style=flat-square)](https://rubygems.org/gems/powerapi)

PowerAPI-ruby
============
Library for fetching information from PowerSchool SISes.

Requirements
------------
* Ruby >= 2.0.0
* PowerSchool 8.x; PowerSchool >= 7.1.0

Installation
------------
You should use [RubyGems](https://rubygems.org/) to handle including/downloading
the library for you.

```
$ gem install powerapi
```

Usage example
-------------
```ruby
require "powerapi"

# Trade server details and the user's credentials for a student object.
student = PowerAPI.authenticate("http://powerschool.example", "username", "password")

# Print the student's name.
print student.information["firstName"] + " " + student.information["lastName"] + "\n"

# Print the student's sections.
student.sections.each do |section|
  print section.name + "\n"
end
```


## License

    Copyright (c) 2014 Henri Watson

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
