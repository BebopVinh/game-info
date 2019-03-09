class GameInfo::CLI
    attr_reader :input
    def call
      puts 'Top Games streaming on Twitch.tv:'
      list_games
      print  "\n\nLast updated: " + GameInfo::Scraper.time
			print "\n\nPlease select a game by its [number], or input 'exit': "
      @input = gets.strip.downcase
      until @input == 'exit'
        if (1..GameInfo::Scraper.games.length).include?(@input.to_i)
          @input = @input.to_i - 1
          game = self.inspect(@input)
          self.print_info(game)
        else
          puts "Invalid input, please try again."
          puts "Please select a game by its [number], or input 'exit': "
          @input = gets.strip.downcase
        end
      end
      quit_it
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
      puts "(Loading...) --> || #{chosen_game} ||"
      if GameInfo::Game.void.include?(chosen_game)
        puts "\nThis is a variety category stream on Twitch. It does not pertain to video games."
        continue
      else
        game = GameInfo::Scraper.find_info(chosen_game)
      end
    end

    def print_info(game)
      binding.pry
      puts <<-DOC
        ---------------

        Developers: #{game.developers.join(', ')}
        Publishers: #{game.publishers.join(', ')}
        Genres: #{game.genres.join(', ')}
        Game Modes: #{game.modes.join(', ')}
        Platforms-Release Date: #{game.platform_release.join(', ')}

        --------------
      DOC
      continue
    end

    def continue
      input = nil
      puts "\nEnter [y] to return to menu, [n] to exit"
      input = gets.strip.downcase
      if input == 'y'
        call
      elsif input == 'n'
        quit_it
      else
        puts "Invalid input."
        continue
      end
    end

    def quit_it
      puts "Thank you for using Game-Info CLI!"
      exit!
    end
end