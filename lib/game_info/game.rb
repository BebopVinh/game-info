class GameInfo::Game
    attr_accessor :name, :viewers, :platform, :genre
    @@all = []
    test_case = {name: 'Test', viewers: '150K', platform: 'PS4, XOne, Switch, PC', genre: 'fighting'}

    def initialize(game_hash)
        game_hash.each {|key, value| self.send(("#{key}="), value)}
        # game_hash.each{|key, value| puts '#{key}, #{value}'}
        @@all << self
    end

    def self.create(game_hash)
        game_hash.each{|key,value| puts "#{key}, #{value}"}
    end

    def self.all
        @@all
    end
    
    game = self.new(test_case)
end