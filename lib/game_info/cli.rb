class GameInfo::CLI
    attr_reader :input
    def call
      GameInfo::Scraper.new if GameInfo::Game.twitch.empty?
      puts "Top 10 Games streaming on Twitch.tv:\n\n"
        list_twitch_games
      puts  "\nLast updated: " + GameInfo::Scraper.time
      puts  "\nInput the commands below:
              \n  Select a game by its [number].
              \n  Use 'menu' to show more features.
              \n  Use 'exit' to terminate the program."
      @input = gets.strip.downcase
      until @input == 'exit'
        if @input == 'menu'
          show_menu
        elsif @input.to_i.between?(1, GameInfo::Game.twitch.size)
          @input = @input.to_i - 1
          choose_game(@input)
        else
          input_invalid
        end
      end
      quit_it
    end #end of call

		def list_twitch_games
      GameInfo::Game.twitch.each_with_index do |game, i|
        puts "[#{i+1}]".ljust(5) + 
        "#{game.name} || #{game.viewers} average viewers"
      end
    end

    def choose_game(input)
      chosen_game = GameInfo::Game.twitch[input].name
      game = GameInfo::Game.find_game(chosen_game)
      if game.developers
        print_info(_)
      else
      puts "(Loading...) --> || #{game.name} ||"
        if GameInfo::Game.void.include?(game.name)
          puts "\nThis is a variety category stream on Twitch. It does not pertain to video games."
          continue('call')
        else
          game.url = '/games/' + game.name.downcase.gsub(/[^0-9a-z\- ]/, "").gsub(' ', '-')
          GameInfo::Scraper.find_info(game)
          print_info(game)
          continue('call')
        end
      end
    end #End of choosen_game method

    def search_by_name
      puts "Please enter the game's name:"
      @input = gets.strip
      if GameInfo::Game.find_game(@input)
        game = GameInfo::Game.find_game(@input)
        puts "Game is available in library!"
        print_info(game)
        continue('show_menu')
      else
        name = @input.downcase.gsub(/[^0-9a-z\- ]/, "").gsub(' ', '+')
        results = GameInfo::Scraper.search_list(name)
        if results.size < 1
          puts "No results found. Retry? [y/n]"
          choice = gets.strip.downcase
          if choice == 'y'
            search_by_name
          elsif choice == 'n'
            continue('show_menu')
          else
            input_invalid
          end
        else
          print_results(results)
        end
      end
      show_menu
    end #End of search_by_name

    def print_results(results)
      puts "Here are some results:"
      results.each_with_index {|hash, i| puts "[#{i+1}]   #{hash.keys.join}"}
      puts "Please choose a game by its [number], or 'exit'"
      until @input == 'exit'
        @input = gets.strip.downcase
        if @input.to_i.between?(1, results.size)
          @input = @input.to_i - 1
          chosen_game = results[@input].keys.join
          game = GameInfo::Game.new(chosen_game)
          game.url = results[@input].values.join
          puts "(Loading...) --> || #{game.name} ||"
          GameInfo::Scraper.find_info(game)
          print_info(game)
          binding.pry
          continue('show_menu')
        else
          input_invalid
        end
      end
    end

    def print_info(game)
      puts <<-DOC
        ------------------------------

        Developers: #{game.developers.join(', ')}
        Publishers: #{game.publishers.join(', ')}
        Genres: #{game.genres.join(', ')}
        Game Modes: #{game.modes.join(', ')}
        Platforms & Release Dates:
      DOC
        game.platform_release.each {|x| puts "          #{x}"}
        puts "\n        ------------------------------"
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

    def reload_list
      puts "Reloading... may freeze momentarily..."
      GameInfo::Game.twitch.clear
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

    def input_invalid
      puts "Invalid input, please try again."
      @input = gets.strip.downcase
    end
    
    def continue(chosen_method)
      puts "\nEnter [y] to return to previous, [n] to exit"
      @input = gets.strip.downcase
      if @input == 'y'
        (chosen_method == 'call')? call : show_menu
      elsif @input == 'n'
        quit_it
      else
        input_invalid
      end
    end

    def quit_it
      puts "\nThank you for using Game-Info CLI!"
      exit!
    end
end