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


    def self.find_info(game)
      doc = Nokogiri::HTML(open('https://www.igdb.com' + game.url)) 
      game.platform_release = doc.css('div.text-muted.release-date').map do |tag|
        platform = tag.css('a').text
        release = tag.css('span time').text
        "#{platform} - #{release}"
      end

      if x = doc.css("div.optimisly-game-maininfo")
        game.developers = x.xpath("//div[@itemprop='author']/span/a").map do |tag|
          tag.text
        end

        game.publishers = x.xpath("//span[@itemprop='publisher']/span/a").map do |tag|
          tag.text
        end
      end

      if x = doc.css('div.optimisly-game-extrainfo1')
        node = x.css('label.mar-lg-top')
        game.modes = node.xpath("//a[@itemprop='playMode']").map do |tag|
          tag.text
        end

        game.genres = node.xpath("//a[@itemprop='genre']").map do |tag|
          tag.text
        end
      end
    end

    def self.search_list(name)
      search_url = 'https://www.igdb.com/search?utf8=%E2%9C%93&type=1&q='
      doc = Nokogiri::HTML(open(search_url + name))
      node = doc.xpath("//div[@class='block']/*").first.to_h["data-json"]
      if node == nil
        array = []
      else
        node = JSON.parse(node)
        array = node.map do |x|
          name = x["data"]["name"]
          url = x["data"]["url"]
          hash = {name => url}
        end
        array.slice!(0..9)
      end
    end #End of self_search method
    
    def self.games
      @@games
    end

    def self.time
      @@time
    end

end #END OF SCRAPER CLASS
