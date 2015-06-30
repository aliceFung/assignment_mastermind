# Set up the game [mastermind]
  # Create a game board [board]
  # Create two players: Code-maker and code-breaker [player]
  # Code maker makes code #(solution) [board]
# Start the game loop (12 tries) [mastermind]
  # Render the board [board]
  # Take code-breaker guess [player]
  # Validate guess (valid input) [player]
  # Compare guess to solution [ask board]
    #If guess is correct -
      #end game [mastermind]
    #Else -
      #show information on guess [board]
        # Number of correct colored pegs in correct position [board]
        # Correct colored pegs in wrong position [board]
#end game [mastermind]
  #show actual solution [board]
  #replay [mastermind]

class Mastermind #Game flow

  def initialize
    @code_breaker = Player.new
    @code_maker = Computer.new
    @board = Board.new(@code_maker.solution)
  end

  def play
    @tries = 12
    @board.render
    keep_playing = true
    while keep_playing #All the games - until player quits
      while @tries >= 0 #Single game
        #player guess
        @code_breaker.guess
        #board compares guess to solution
        if @guess == @solution
          win_game
          break
        else
          @tries -=1
          @board.render #colored pegs hints
        end
      end
      lose_game if @tries <= 0
      keep_playing = play_again?
    end
  end

  def win_game
    puts "Congratulations! Your code was correct!"
  end

  def lose_game
    puts "Sorry! The solutions was:"
    @board.show_solution
  end

  def play_again?
    is_valid = false
    until is_valid
      print "Do you want to play again? (Y/N): "
      input = gets.chomp.downcase
      is_valid = is_true_or_false?(input)
      puts "Try 'y' or 'n'" unless is_valid
    end
    return input == "y"
  end


  def is_true_or_false?(input)
    ["y", "n"].include?(input)
  end

end

class Board #Game logic

  def initialize(solution)
    @board = Array.new(12) { |row| row = ["-","-","-","-"] }
    @solution = solution
  end

  def render
    p @board
  end

  def compare_solution

  end

  def show_hints

  end

  def show_solution
    puts @solution
  end


end

class Player #Inputs

  VALID_OPTIONS = %w(b r y p g o)

  def initialize

  end

  def guess
    input_valid = false
    until input_valid
      print "Enter your guess (e.g. b,r,y,g): "
      raw_input = gets.strip
      move = raw_input.split(",")
      input_valid = is_input_valid?(move)
    end
    return move #might not work - check scope
  end

  def is_input_valid?(input)
    VALID_OPTIONS.include?(input)
  end

end

class Computer #as code maker

  CODE_COLORS = %w(b r y p g o)

  def initialize
    @solution = make_code
  end

  def solution
    @solution
  end

  def make_code
    #generate random code of 6 colors
    CODE_COLORS.sample(4)
  end

end

