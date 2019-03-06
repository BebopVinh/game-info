class GameInfo::CLI
		@@games = ['Fortnite', 'LOL', 'Apex Legends', 'WOW', 'DOTA2']
    def call
			puts 'Top Games streaming on Twitch.tv:'
			self.list_games
			puts "Select a game by its [number], or input 'exit' "
			binding.pry
			@input = gets.chomp.downcase
			if (1..@@games.length).include?(@input.to_i)
					@input = @input.to_i - 1
					self.inspect(@input)
			elsif @input == 'exit'
				puts "Thank you for using Game-Info CLI!"
			else
				puts 'Invalid input, please try again.'
			end
    end

    def list_games
			puts <<-DOC.gsub(/^\s+/, "")
					1. Fortnite
					2. League of Legends
					3. Apex Legends
					4. World of Warcraft
					5. Dota 2
			DOC
    end

		def inspect(input)
			game = @@games[input]
			puts "The game you've selected is #{game}."
    end

end