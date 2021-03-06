class GameInfo::Game
    attr_accessor :developers, :publishers, :modes, :esrb, :reviews,
                  :name, :viewers, :platform_release, :genres, :url
    @@all = []
    @@twitch = []

    @@void = ['Just Chatting', 'Music & Performing Arts', 'ASMR', 'Talk Shows & Podcasts', 
    'Science & Technology', 'Food & Drink', 'Makers & Crafting', 'Travel & Outdoors', 
    'Sports & Fitness', 'Beauty & Body Art', 'Special Events', 'Wrestling', 'Always On']

    def initialize(name)
      @name = name
      @@all << self
    end

    def add_info(game_hash)
      game_hash.each {|key, value| self.send(("#{key}="), value)}
      self
    end

    def self.all
      @@all
    end

    def self.void
      @@void
    end

    def self.twitch
      @@twitch
    end

    def self.find_game(name)
      @@all.find{|game| game.name == name}
    end
    
    def self.find_or_create_game(name)
      find_game(name) || new(name)
    end

end