class Player
	attr_reader :marker, :name
	attr_accessor :guesses
	
	@@player_number = 0
	
	def initialize
		@@player_number += 1
		setup
	end
	
	def setup
		puts "Player #{@@player_number}: What is your name?"
		@name = gets.chomp
		@marker = @@player_number == 1 ? "X" : "O"
		@guesses = Array.new
	end
	
end

class Board
	
	Wins = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
	
	def initialize
		@cells = *(0..9)
		@cells[0] = nil
	end
	
	def turn(player, guess)
		if guess < 1 || guess > 9
			puts "Only numbers between 1 and 9 ta."
			return false
		elsif ["X","O"].include? @cells[guess]
			puts "Already taken."
			return false
		end
		@cells[guess] = player.marker
		player.guesses << guess
	end
	
	def draw
		puts "\n"
		puts " #{@cells[1]} | #{@cells[2]} | #{@cells[3]}"
		puts "---+---+---"
		puts " #{@cells[4]} | #{@cells[5]} | #{@cells[6]}"
		puts "---+---+---"
		puts " #{@cells[7]} | #{@cells[8]} | #{@cells[9]}"
	end
	
	def check_win(moves)
		Wins.each do |w|
			return true if w.select {|i| moves.include? i }.count == 3
		end
		false
	end
	
end


class Game
	def initialize
		@board = Board.new
		@player = []
		@player << Player.new << Player.new
		@turn_id = 0
	end
	
	def play
		@board.draw
		while true
			puts "\n"
			puts "#{@player[@turn_id].name}, place your #{@player[@turn_id].marker}"
			move = gets.chomp.to_i
			if @board.turn(@player[@turn_id], move)
				@board.draw
				if @board.check_win(@player[@turn_id].guesses)
					puts "\n#{@player[@turn_id].name} wins! Good job!"
					break
				elsif @player[@turn_id].guesses.count > 4
					puts "\nDRAW."
					break
				end
				@turn_id = (@turn_id == 0 ? 1 : 0)
			end
		end
	end
	
end

Game.new.play