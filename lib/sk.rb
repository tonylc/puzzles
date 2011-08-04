require 'net/http'
require 'rubygems'
require 'nokogiri'
require 'json'

def get_url(url)
  p "*** request to #{url}"
  url = URI.parse(url)
  req = Net::HTTP::Get.new(url.path)
  res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
  res.body
end

all_concerts = []
response = get_url('http://www.wegottickets.com/searchresults/page/1/all')

page = 1
doc = Nokogiri::HTML(response)
total_pages = doc.css('.paginator .pagination_link').last.text.to_i

while page <= total_pages
  doc.css('.ListingOuter .ListingWhite').each do |concert|
    act = concert.css('.ListingAct')
    venue_logo = act.css('.venue-logo img').attr('src').text
    act_link = act.css('.event_link').attr('href').text
    musician = act.css('.event_link').text
    city = act.css('.venuetown').text
    venue = act.css('.venuename').text
    date = act.css('blockquote p').children.last.text
    price = concert.css('.ListingPrices strong').text
    prices = concert.css('.ListingPrices .searchResultsPrice').children
    if !prices.empty?
      num_tickets_string = prices.first.text 
      num_tickets = num_tickets_string.match(/^(\d+)/)
      num_available = num_tickets[1] if num_tickets
    end
    # if it starts with the gbp symbol, slice it off
    price = price.slice(2, price.length) if price.start_with?("\302\243")

    all_concerts << {
      :venue_logo => venue_logo,
      :act_link => act_link,
      :musician => musician,
      :city => city,
      :venue => venue,
      :date => date,
      :price => price,
      :venue_logo => venue_logo,
      :act_link => act_link,
      :num_available => num_available || 'unknown'
    }
  end
  page += 1
  break if page > total_pages
  response = get_url("http://www.wegottickets.com/searchresults/page/#{page}/all")
  doc = Nokogiri::HTML(response)
end

File.open("concerts.json", 'w') do |f|
  f.write(all_concerts.to_json)
end
