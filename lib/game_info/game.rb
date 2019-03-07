class GameInfo::Game
    attr_accessor :name, :viewers, :platform_release, :genres
    @@all = []

    # @@void = ['Just Chatting', 'Music & Performing Arts', 'ASMR', 'Talk Shows & Podcasts', 
    # 'Science & Technology', 'Food & Drink', 'Makers & Crafting', 'Travel & Outdoors', 
    # 'Sports & Fitness', 'Beauty & Body Art', 'Special Events']

    def initialize(game_hash)
        game_hash.each {|key, value| self.send(("#{key}="), value)}
        @@all << self
    end

    def self.all
        @@all
    end
    
    def self.find_game(name)
      @@all.find{|game| game.name == name}
    end

    def self.find_or_create(name)
      find_game(name) || new(name)
    end
end