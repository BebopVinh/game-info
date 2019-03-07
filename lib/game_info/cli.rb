class GameInfo::CLI
    def call
			puts 'Top Games streaming on Twitch.tv:'
			self.list_games
			puts "Select a game by its [number], or input 'exit' "
			@input = gets.chomp.downcase
			if (1..GameInfo::Scraper.games.length).include?(@input.to_i)
					@input = @input.to_i - 1
					self.inspect(@input)
			elsif @input == 'exit'
				puts "Thank you for using Game-Info CLI!"
			else
				puts 'Invalid input, please try again.'
			end
    end

		def list_games
			i = 1
			GameInfo::Scraper.new.games.each do |game|
				puts "[#{i}]  #{game[:name]} - @#{game[:viewers]} average viewers"
				i += 1
			end
    end

		def inspect(input)
			game = GameInfo::Scraper.games[input][:name]
			
			puts "The game you've selected is #{game}:"
			GameInfo::Scraper.find_info(game)
    end

end