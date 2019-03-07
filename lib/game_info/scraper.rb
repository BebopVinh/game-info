class GameInfo::Scraper
    # @@void = ['Just Chatting', 'Music & Performing Arts', 'ASMR', 'Talk Shows & Podcasts', 'Science & Technology', 'Food & Drink', 'Makers & Crafting', 'Travel & Outdoors', 'Sports & Fitness', 'Beauty & Body Art', 'Special Events']
    doc = Nokogiri::HTML(open('https://www.twitchmetrics.net/games/popularity'))
    @@game_names = doc.css('h5.mr-2.mb-0')
    @@viewers = doc.css('div.mb-2 div samp')
    @@games = []
    def initialize
      i = 0
      10.times do 
        name = @@game_names[i].text.strip
        viewers = @@viewers[i].text.strip
        @@games << {name: name, viewers: viewers}
        i += 1
      end
    end

    def self.find_info
      igdb = 'https://www.igdb.com/games/'
      name = chosen_game.downcase.gsub(' ', '-')
      info = Nokogiri::HTML(open(igdb + name))
    end

    def self.games
      @@games
    end
end
