class GameInfo::Game
    attr_accessor :name, :viewers, :platform, :genre
    @@all = []

    def initialize(name)
        
        @@all << self
    end

    def self.all
        @@all

    end
end