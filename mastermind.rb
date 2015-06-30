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

require 'pry-byebug'

class Mastermind #Game flow

  def initialize
 #  binding.pry
    @code_breaker = Player.new
    @code_maker = Computer.new
    @board = Board.new
  end

  def play
    tries = 12
    @board.render
    keep_playing = true
    while keep_playing #All the games - until player quits
      while tries > 0 #Single game

        guess = @code_breaker.guess

        if guess_correct?(guess)
          win_game
          break
        else
          @board.update(guess, tries)
          @board.render
          hints(guess)
          tries -=1
        end
      end
      lose_game if tries <= 0
      keep_playing = play_again? #need to reset board
    end
  end

  def hints(guess)
    # p @code_maker.solution
    puts compare_exact_match(guess)
  end

  def compare_exact_match(guess)
    guess_copy = guess.dup
    code = @code_maker.solution.dup
    result = {:exact_match => 0}

    guess_copy.each_with_index do |color, index|
      if color == code[index]
        result[:exact_match] +=1
        code[index] = nil
        guess_copy[index] = nil
      end
    end
    code.select!{ |item| item != nil}
    guess_copy.select!{ |item| item != nil}
    result[:color_match] = compare_color_match(code, guess_copy)
    result
  end

  def compare_color_match(code, guess)
    p code
    result = {:color_match => 0}

    guess.each_with_index do |color, index|
      if code.include?(color)
        result[:color_match] += 1
        code[code.index(color)] = nil
        puts color
        puts index
      end

    end

    result[:color_match]
  end

  def guess_correct?(guess)
    guess == @code_maker.solution
  end

  def win_game
    puts "Congratulations! Your code was correct!"
  end

  def lose_game
    puts "Sorry! The solutions was:"
    puts @code_maker.solution
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

  def initialize
    @board = Array.new(12) { |row| row = ["-","-","-","-"] }
  end

  def render
    p @board
  end

  def update(guess, tries)
    @board[12 - tries]= guess
  end

  def show_hints (guess, solution)
    #
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
      puts "Input is invalid. Please try again." unless input_valid
    end
    return move #might not work - check scope
  end

  def is_input_valid?(input)
    input.all?{ |item| VALID_OPTIONS.include?(item)}
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
    code = []
    #generate random code of 6 colors
    4.times do
      code << CODE_COLORS.sample
    end
    code
  end

end

a = Mastermind.new
a.play
