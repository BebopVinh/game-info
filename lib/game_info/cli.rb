class GameInfo::CLI
    attr_reader :input
    def call
      puts "Top 10 Games streaming on Twitch.tv:\n\n"
      list_games
      puts  "\nLast updated: " + GameInfo::Scraper.time
      puts  "\nInput the commands below:
              \n  Select a game by its [number].
              \n  Use 'menu' to show more features.
              \n  Use 'exit' to terminate the program."

      @input = gets.strip.downcase
      until @input == 'exit'
        if @input == 'menu'
          show_menu
        elsif (1..GameInfo::Scraper.games.length).include?(@input.to_i)
          @input = @input.to_i - 1
          game = self.choose_game(@input)
          self.print_info(game)
        else
          input_invalid
        end
      end
      quit_it
    end

		def list_games
      GameInfo::Scraper.games.each_with_index do |game, i|
				puts "[#{i+1}]  #{game[:name]} || #{game[:viewers]} average viewers"
      end
    end

    def choose_game(input)
      if input.is_a? FixNum
        chosen_game = GameInfo::Scraper.games[input][:name]
        puts "(Loading...) --> || #{chosen_game} ||"
        if GameInfo::Game.void.include?(chosen_game)
          puts "\nThis is a variety category stream on Twitch. It does not pertain to video games."
          continue
        else
          game = GameInfo::Scraper.find_info(chosen_game)
        end
      end
    end #End of choose_game method

    def print_info(game)
      puts <<-DOC
        ------------------------------

        Developers: #{game.developers.join(', ')}
        Publishers: #{game.publishers.join(', ')}
        Genres: #{game.genres.join(', ')}
        Game Modes: #{game.modes.join(', ')}
        Platforms & Release Dates:
      DOC
        game.platform_release.each {|x| puts "            #{x}"}
        puts "\n        ------------------------------"
      continue
    end

    def show_menu
      puts <<-DOC
        Select a function by the first letter:
        [B]ack to welcome screen
        [R]eload Top 10 list
        [S]earch game by name
        [E]xit
      DOC
      @input = gets.strip.downcase
      until @input == ('exit' || 'e')
        if input == 'b'
          call
        elsif input == 's'
          search_by_name
        elsif input == 'r'    
          reload_list
        else
          input_invalid    
        end
      end
    end

    def search_by_name
      puts "Please enter the game's name:"
      @input = gets.strip.downcase
      if GameInfo::Game.find_game(@input)
        game = GameInfo::Game.find_game(@input)
        print_info(game)
      else
        name = @input.gsub(/[^0-9a-z\- ]/, "").gsub(' ', '+')
        results = GameInfo::Scraper.search_list(name)
        if results.size < 1
          puts "No results found."
          search_by_name
        else
          puts "Here are some results:"
          results.each_with_index {|hash, i| puts "#{i+1}. #{hash.keys.join}"}
          puts "Please choose a game by its [number], or 'exit'"
          until @input == 'exit'
            @input = gets.strip.downcase
            if @input.to_i.between?(1, results.size)
              @input = @input.to_i - 1
              chosen_game = results[@input].keys.join
              url = 'https://www.igdb.com' + results[@input].values.join
              binding.pry
              puts "(Loading...) --> || #{chosen_game} ||"
              game = GameInfo::Scraper.find_info(chosen_game, url)
              print_info(game)
              continue
            else
              input_invalid
            end
          end
        end
      end
      show_menu
    end

    def input_invalid
      puts "Invalid input, please try again."
      @input = gets.strip.downcase
    end

    def reload_list
      puts "Reloading... may freeze momentarily..."
      GameInfo::Scraper.new
      puts "Done! Return to welcome screen? [y/n]"
      @input = gets.strip.downcase
      if @input == 'y'
        call
      elsif @input == 'n'
        show_menu
      else
        input_invalid
      end
    end

    def continue
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
      puts "\nThank you for using Game-Info CLI!"
      exit!
    end
end