class Player
  attr_reader :marker, :name, :ai
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
    @guesses = Array.new # Array of moves for each player to check win / draw
    puts "Are you a dumb computer player? (y/n)" # And I mean really dumb
    @ai = true if gets.chomp.upcase == "Y"
  end
  
end

class Board
  
  Wins = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]] # All possible win combinations on the board
  
  def initialize
    @cells = *(0..9) # Splat operator creates an array of ten items, zero to nine
    @cells[0] = nil # Ignore the 0th element
  end
  
  def turn(player, guess)
    if guess < 1 || guess > 9
      puts "Only numbers between 1 and 9 ta."
      return false
    elsif ["X","O"].include? @cells[guess] # Kind of backwards way of checking if the chosen cell is already an X or O
      puts "Already taken."
      return false
    end
    @cells[guess] = player.marker # Mark the move on the board
    player.guesses << guess # Add the cell number to the player's guesses
  end
  
  def draw # Draws the board
    puts "\n"
    puts " #{@cells[1]} | #{@cells[2]} | #{@cells[3]}"
    puts "---+---+---"
    puts " #{@cells[4]} | #{@cells[5]} | #{@cells[6]}"
    puts "---+---+---"
    puts " #{@cells[7]} | #{@cells[8]} | #{@cells[9]}"
  end
  
  def check_win(moves) # Checks player's moves array vs. list of possible wins
    Wins.each do |w|   # Return true if any three numbers in player's moves match all three of any of the win values
      return true if w.select { |i| moves.include? i }.count == 3
    end
    false
  end

  def ai_move # If player is an AI, picks any available space at random for their move.
    left = @cells[1..10].reject { |i| i == "X" || i == "O" } # Told you it was stupid
    return left.sample
  end
  
end


class Game # Controls game logic
  def initialize
    @board = Board.new
    @player = []
    @player << Player.new << Player.new # Initializes two players into an array
    @turn_id = 0 # To keep track of whose turn it is - used as index for player array
  end
  
  def play
    @board.draw
    while true
      puts "\n"
      puts "#{@player[@turn_id].name}, place your #{@player[@turn_id].marker}"
      if @player[@turn_id].ai
        move = @board.ai_move
        sleep 1.5
      else
        move = gets.chomp.to_i
      end
      if @board.turn(@player[@turn_id], move) # i.e. as long as player input is a valid choice (controlled by Board.turn)
        @board.draw
        if @board.check_win(@player[@turn_id].guesses)
          puts "\n#{@player[@turn_id].name} wins! Good job!"
          break
        elsif @player[@turn_id].guesses.count > 4 # If a player has made 5 moves without a win it must be a draw
          puts "\nDRAW."
          break
        end
        @turn_id = (@turn_id == 0 ? 1 : 0) # Make it the other guy's turn
      end
    end
  end
  
end

Game.new.play
