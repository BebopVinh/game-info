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

    def self.find_info(chosen_game, url = "")
      name = chosen_game.downcase.gsub(/[^0-9a-z\- ]/, "").gsub(' ', '-')
      if url == ""
        doc = Nokogiri::HTML(open('https://www.igdb.com/games/' + name))
      else
        doc = Nokogiri::HTML(open(url))
      end
        hash = {}
      y = hash[:platform_release] = [] 
      doc.css('div.text-muted.release-date').each do |tag|
        platform = tag.css('a').text
        release = tag.css('span time').text
        y << "#{platform} - #{release}"
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

      if x = doc.css('div.optimisly-game-extrainfo1')
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

      game = GameInfo::Game.find_or_create_game(chosen_game)
      game.add_info(hash)
      game
    end

    def self.search_list(name)
      search_url = URI.escape('https://www.igdb.com/search?utf8=✓&type=1&q=')
      doc = Nokogiri::HTML(open(search_url + name))
      node = doc.xpath("//div[@class='block']/*").first.to_h["data-json"]
      node = JSON.parse(node)
      array = node.map do |x|
        name = x["data"]["name"]
        url = x["data"]["url"]
        hash = {name => url}
      end
      array.slice!(0..9)
    end
    
    def self.games
      @@games
    end

    def self.time
      @@time
    end

end #END OF SCRAPER CLASS
