class GameInfo::Scraper
    attr_reader :time, :game_names, :viewers
    @@doc = Nokogiri::HTML(open('https://www.twitchmetrics.net/games/popularity'))
    @@games = []
    def initialize
      @game_names = @@doc.css('h5.mr-2.mb-0')
      @viewers = @@doc.css('div.mb-2 div samp')
      i = 0
      10.times do 
        name = @game_names[i].text.strip
        viewers = @viewers[i].text.strip
        @@games << {name: name, viewers: viewers}
        i += 1
      end
      @@time = @@doc.css('time.time_ago').text
      @@games.each {|hash| GameInfo::Game.new(hash)}
    end

    def self.find_info(chosen_game)
      name = chosen_game.downcase.delete(?').gsub(' ', '-')
      doc = Nokogiri::HTML(open('https://www.igdb.com/games/' + name)) #old database link
      hash = {}
      doc.css('div.text-muted.release-date').each do |tag|
        platform = tag.css('a').text
        release = tag.css('span time').text
        hash[:platform_release] = [] << "#{platform} - #{release}"
      end

      doc.css('div.optimisly-game-maininfo span').each do |tag|
        binding.pry
      end

      game = GameInfo::Game.find_game(chosen_game)
      game.add_info(hash)
      binding.pry
    end

    def self.games
      @@games
    end

    def self.time
      @@time
    end
end
