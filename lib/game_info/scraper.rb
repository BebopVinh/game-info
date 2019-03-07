class GameInfo::Scraper
    # @@void = ['Just Chatting', 'Music & Performing Arts', 'ASMR', 'Talk Shows & Podcasts', 'Science & Technology', 'Food & Drink', 'Makers & Crafting', 'Travel & Outdoors', 'Sports & Fitness', 'Beauty & Body Art', 'Special Events']
    doc = Nokogiri::HTML(open('https://www.twitchmetrics.net/games/popularity'))
    game_name = doc.css('h5.mr-2.mb-0')
    num_viewers = doc.css('div.mb-2 div samp')
    i = 0
    @@games = []
    10.times do 
        hash = {}
        name = game_name[i].text 
        viewers = num_viewers[i].text
        hash[:name] = name
        hash[:viewers] = viewers
        @@games << hash
        i += 1
    end

    def self.find_info(chosen_game)
        igdb = 'https://www.igdb.com/games/'
        name = chosen_game.strip.downcase.gsub(' ', '-')
        info = Nokogiri::HTML(open(igdb + name))
        binding.pry
    end

    def self.games
        @@games
    end
end
