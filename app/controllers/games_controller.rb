require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:grid]

    if included?(@word, @letters) == false
      @score = "Sorry but #{@word} can't be build out of the grid !"
    elsif english_word?(@word) == false
      @score = "Sorry but #{@word} is not an english word !"
    else
      @score = 'Well done !'
    end
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def included?(guess, grid)
    attempt = guess.upcase
    attempt.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end
end
