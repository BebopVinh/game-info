class GameInfo::Scraper
    doc = Nokogiri::HTML(open('https://www.twitch.tv/directory'))

    game_data = doc.css('div.tw-mg-')
    binding.pry
end

#div.tw-card-body.tw-relative > div > div > h3
#div.tw-card-body.tw-relative > p