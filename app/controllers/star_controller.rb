require 'mechanize'
require 'nokogiri'
require 'open-uri'

class StarController < ApplicationController
  def crawl




		star = {}
		counter = 0
		base_url = "http://en.wikipedia.org/wiki/"
		twitter_base = "https://twitter.com/"

		doc = Mechanize.new { |agent|
		  agent.user_agent_alias = 'Mac Safari'
		}

		page = doc.get('http://en.wikipedia.org/wiki/List_of_American_film_actresses')

		page.body.split("\n").each do |k|
			line = k.chomp

			if line.match(/<li><a href="\/wiki\/(.*?)" title=".*?">(.*?)<\/a>/)
			





				star[:name] = $2
				# star[:url] = "#{base_url}#{$1}"	
				url = "#{base_url}#{$1}"	
				

				star_page = doc.get(url)
				star_page.body.split("\n").each do |d|
					sline = d.chomp

					if tw = sline.match(/<li><a rel="nofollow" class="external text" href="https:\/\/twitter.com\/(.+?)">/)
							star[:twitter] = "#{twitter_base}#{tw[1]}"
							# puts "TWITTER"
						end		
					
				end
				@star = Star.new(name: "#{star[:name]}", twitter: "#{star[:twitter]}")

				puts star

				
				@star.save
				counter += 1
				star = {}
				
			end
				
		end

  end
end
