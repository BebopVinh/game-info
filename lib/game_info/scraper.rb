class GameInfo::Scraper

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
      @@games.each {|hash| GameInfo::Game.new(hash)}
      binding.pry
    end

    def find_info(chosen_game)
        igdb = 'https://www.igdb.com/games/'
        name = chosen_game.downcase.gsub(' ', '-')
        info = Nokogiri::HTML(open(igdb + name))
        hash = {}
        hash[:platform_release] = ""
    end

    def self.games
      @@games
    end
end
