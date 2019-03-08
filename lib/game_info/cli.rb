class GameInfo::CLI
    attr_reader :scraper, :input
    def call
      @scraper = GameInfo::Scraper.new
			puts 'Top Games streaming on Twitch.tv:'
      self.list_games
      print  "\n\nLast updated: " + @scraper.time
			print "\n\nPlease select a game by its [number], or input 'exit': "
      @input = gets.strip.downcase
      until @input == 'exit'
        if (1..GameInfo::Scraper.games.length).include?(@input.to_i)
          @input = @input.to_i - 1
          self.inspect(@input)
        else
          puts "Invalid input, please try again."
          puts "Please select a game by its [number], or input 'exit': "
          @input = gets.strip.downcase
        end
      end
      puts "Thank you for using Game-Info CLI!"
    end

		def list_games
			i = 1
      GameInfo::Scraper.games.each do |game|
				puts "[#{i}]  #{game[:name]} - @#{game[:viewers]} average viewers"
				i += 1
      end
    end

		def inspect(input)
			chosen_game = GameInfo::Scraper.games[input][:name]
			puts "The game you've selected is #{chosen_game}:"
			GameInfo::Scraper.find_info(chosen_game)
    end

end