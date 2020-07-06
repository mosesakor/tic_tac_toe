require 'pry'



class Game
    @@round = 0
    @@winner = nil
    @@player1 = nil
    @@player2 = nil
    
    @@a1 = " "
    @@a2 = " "
    @@a3 = " "
    @@b1 = " "
    @@b2 = " "
    @@b3 = " "
    @@c1 = " "
    @@c2 = " "
    @@c3 = " "

    @@available_fields = ["a1", "a2", "a3", "b1", "b2", "b3", "c1", "c2", "c3"]
    @@win_combinations = [["a1", "a2", "a3"], ["b1", "b2", "b3"], ["c1", "c2", "c3"],
    ["a1", "b1", "c1"], ["a2", "b2", "c2"], ["a3", "b3", "c3"],
    ["a1", "b2", "c3"], ["c1", "b2", "a3"]]


    def initialize
    end

    def self.get_fields
        @@available_fields
    end

    def get_input
        correct_input = false
        until correct_input == true
            puts "#{@@current_player.name} choose an empty field: "
            begin
                player_input = Kernel.gets.match(/^[abc][123]{1}$/)[0]
            rescue
                puts "Erroneous input! See input style: (a1,B2)"
            else
                player_input
                correct_input = true
            end
        end
        if @@available_fields.include?(player_input)
            @@available_fields.delete(player_input)
            correct_input = true
            player_input
        else
            puts "Unavailable field! See available fields #{@@available_fields}"
            get_input
        end
    end

    def insert_input(field)
        case field
        when "a1"
            @@a1 = @@current_player.element
        when "a2"
            @@a2 = @@current_player.element
        when "a3"
            @@a3 = @@current_player.element
        when "b1"
            @@b1 = @@current_player.element
        when "b2"
            @@b2 = @@current_player.element
        when "b3"
            @@b3 = @@current_player.element
        when "c1"
            @@c1 = @@current_player.element
        when "c2"
            @@c2 = @@current_player.element
        when "c3"
            @@c3 = @@current_player.element
        end

        @@round += 1
    end

    def update_combinations
        @@win_combinations.each_with_index do |tiles, index|
            tiles.each_with_index do |tile, index2|
                if @@player_input == tile
                    @@win_combinations[index][index2] = @@current_player.element
                end
            end
        end
    end

    def player_turn
        @@player_input = @@current_player.get_input
        @@current_player.insert_input(@@player_input)
        @@current_player.update_combinations
        Game.display_board
        Game.game_over?
        Game.decide_winner
        Game.get_round
    end

    def play_round()
        until Game.game_over? == true || Game.get_round == 9
            @@current_player = @@player1
            player_turn
            if Game.game_over? == false && Game.get_round < 9
            @@current_player = @@player2
            player_turn
            end
        end
    end

    def self.decide_winner
        if Game.get_winner == @@player1.name
            puts "#{@@player1.name} wins!"
        elsif Game.get_winner == @@player2.name
            puts "#{@@player2.name} wins!"
        elsif Game.get_round == 9
            puts "Game Over! Draw!"
        end
    end

    def start_game
        correct_input = false
        until correct_input == true
            puts "Enter player1 name: "
            begin
                @@player1 = Kernel.gets.match(/\w{3,15}/i)[0]
            rescue
                puts "Error! Make sure input is less than 16 chars"
            else
                puts "#{@@player1} is X"
                @@player1 = Player.new(@@player1, "X")
                correct_input = true
            end
        end
    
        correct_input = false
        until correct_input == true
            puts "Enter player2 name: "
            begin
                @@player2 = Kernel.gets.match(/\w{3,15}/i)[0]
            rescue
                puts "Error! Make sure input is less than 16 chars"
            else
                puts "#{@@player2} is O"
                @@player2 = Player.new(@@player2, "O")
                correct_input = true
            end
        end
        play_round
    end


    def self.get_round
        @@round
    end


    def self.display_board
        @@board = "|#{@@a1}|#{@@a2}|#{@@a3}|\n|#{@@b1}|#{@@b2}|#{@@b3}|\n|#{@@c1}|#{@@c2}|#{@@c3}|"
        puts "#{@@board}"
    end

    def self.game_over?
        if @@win_combinations.include?(["X", "X", "X"])
            @@winner = @@player1.name
            true
        elsif @@win_combinations.include?(["O", "O", "O"])
            @@winner = @@player2.name
            true
        elsif @@round >= 9
            true
        else
            false
        end
    end

    def self.get_winner
        @@winner
    end
end

class Player < Game
    attr_accessor :name, :element

    def initialize(name, element)
        @name = name
        @element = element
    end
end

play1 = Game.new()
play1.start_game
