#!/bin/env ruby

##
## doesn't work, use rake task _vp_ 2023-01-26
##

exit -1

require 'httparty'
require 'json'

def puts! args, label=""
  puts "+++ +++ #{label}"
  puts args.inspect
end

auth = { username: ENV['WP_USERNAME'], password: ENV['WP_PASSWORD'] }
start_date = '2023-01-27'.to_date
count = 3
gallery_url = 'https://manager.piousbox.com/api/galleries/view/202301-pi_wp-Trees.json'

pics = HTTParty.get( gallery_url ).body
pics = JSON.parse( pics )['gallery']['photos']
pics = [ pics[0] ]
pics.each do |pic|
  response = HTTParty.post("${ENV['WP_HOST']}/wp-json/wp/v2/posts",
    basic_auth: auth,
    :headers => {'Content-Type' => 'application/json' },
    body: {
      title: "Tree ##{count}",
      content: "<!--more--><img src='#{pic['small_url']}' />",
      status: 'publish',
      categories: '203', # trees
      date: "#{start_date.to_s}T00:00:00",
      meta: {
        wps_subtitle: "<img src='#{pic['large_url']}' />",
      }
    },
  )
  start_date = start_date + 1.day
  count = count + 1
  puts! response, 'ze response'
end
