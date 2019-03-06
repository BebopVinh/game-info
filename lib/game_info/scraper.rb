class GameInfo::Scraper
    doc = Nokogiri::HTML(open('https://www.twitch.tv/directory'))
end

#div.tw-card-body.tw-relative > div > div > h3
#div.tw-card-body.tw-relative > p