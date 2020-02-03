require 'twitter'
require 'httparty'
require 'nokogiri'

twitter = Twitter::REST::Client.new do |config|
    config.consumer_key        = "JFaqESopdxGmNzvShxGpWCaa1"
    config.consumer_secret     = "CJdu2WEc0NqwUeGzZZEbCWFqzrJhuOC6GsQLQFWJuFoJ7UNXIu"
    config.access_token        = "3369598354-2NaJyOZ9eKFlvcCXFEs7HnKMPcQGCmoJulDyfL4"
    config.access_token_secret = "WQdPZO0aTLooX39dL1hm1M2AiPCwYBocOdfXoZH11Rn58"
end

latest_tweets = twitter.user_timeline("LFC_NewStories")


previous_links = latest_tweets.map do |tweet|
    if tweet.urls.any?
        tweet.urls[0].expanded_url
    end
end

lfc_com = HTTParty.get("https://feed.rssunify.com/5e384082ad5ff/rss.xml")
doc = Nokogiri::XML(lfc_com)

doc.css("item").take(5).each do |item|
    title = item.css("title").text

    link = item.css("link").text

    unless previous_links.include?(link)
        twitter.update("#{title} #{link} #Liverpool #PremierLeague #YNWA")
    end
end