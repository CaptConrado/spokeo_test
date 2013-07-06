require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require "sequel"

# connect to an in-memory database
# DB = Sequel.sqlite
DB = Sequel.connect('sqlite://spoke.db')


# create an items table
DB.create_table :stars do
  primary_key :id
  String :name
  String :url
  String :twitter
end

# create a dataset from the items table
stars = DB[:stars]




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
		star[:url] = "#{base_url}#{$1}"	
		

		star_page = doc.get(star[:url])
		star_page.body.split("\n").each do |d|
			sline = d.chomp

			if tw = sline.match(/<li><a rel="nofollow" class="external text" href="https:\/\/twitter.com\/(.+?)">/)
					star[:twitter] = "#{twitter_base}#{tw[1]}"
					puts "TWITTER"
				end		
			
		end


		puts star
		stars.insert(star)
		counter += 1
		star = {}
		
	end
		puts counter
end

