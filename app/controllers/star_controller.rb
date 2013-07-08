require 'mechanize'
require 'nokogiri'
require 'open-uri'

class StarController < ApplicationController

	def display
		@stars = Star.all
	end

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

			# san_name = ActiveRecord::Base::sanitize($2)
			san_name = $2
			san_name.force_encoding("UTF-8")

			star[:name] = san_name
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
	# cheated
	Star.last.destroy
	Star.last.destroy

	redirect_to '/'
	end

end
