require "open-uri"

class GamesController < ApplicationController
  def random
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
    @letters
  end

  def new
    @letters = random
    while @letters.join.count('AEIOU') < 2
      @letters = random
    end
    @letters
  end

  def score
    if params[:word]
      @word = params[:word]
      @letters = params[:letters_array]
    end
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = URI.open(url).read
    dictionary_hash = JSON.parse(user_serialized)
    if @word.upcase.split('').all? { |letter| @letters.split('').include? letter } && dictionary_hash["found"]
      @result = "Congratulations! #{@word.capitalize} is a valid English word!"
    elsif @word.upcase.split('').all? { |letter| @letters.split('').include? letter }
      @result = "Sorry, but #{@word.capitalize} is not a valid english word..."
    else
      @result = "Sorry, but #{@word.capitalize} cant be built out of #{@letters}"
    end
  end
end
