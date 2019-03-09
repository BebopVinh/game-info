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

      if x = doc.css("div.optimisly-game-maininfo")
        y = hash[:developers] = []
        x.xpath("//div[@itemprop='author']").each do |tag|
          y << tag.css('a').text
        end

        y = hash[:publishers] = []
        x.xpath("//span[@itemprop='publisher']").each do |tag|
          y << tag.css('a').text
        end
      end

      if x=doc.css('div.optimisly-game-extrainfo1')
        node = x.css('label.mar-lg-top')
        y = hash[:modes] = []
        z = hash[:genres] = []
        node.xpath("//a[@itemprop='playMode']").each do |tag|
          y << tag.text
        end

        node.xpath("//a[@itemprop='genre']").each do |tag|
          z << tag.text
        end
      end

      # if x=doc.css('h3.underscratch.underscratch-yellow')
      #   rating = Nokogiri::HTML(open('https://www.igdb.com/games/' + name + '/age_rating'))
      #   # rating = rating.css('img.gamepage-rating-image.img-responsive')['title']
      #   binding.pry
      # end
      game = GameInfo::Game.find_game(chosen_game)
      game.add_info(hash)
      game
    end

    def self.games
      @@games
    end

    def self.time
      @@time
    end
end
