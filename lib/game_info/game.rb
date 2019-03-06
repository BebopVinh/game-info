class GameInfo::Game
    attr_accessor :name, :viewers, :platform, :genre
    @@all = []

    def initialize(name)
    end

    def self.all
        @@all

    end
end