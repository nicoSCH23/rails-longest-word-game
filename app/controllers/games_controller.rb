require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    session[:score] = 0 unless session[:score]
  end

  def score
    @result = 0
    @letters = params[:letters].split(' ')
    @word = params[:word]
    if included?(@word, @letters)
      if english_word?(@word)
        @message = "Congratulations, #{@word.upcase} is a valid English word!"
        @result += @word.length**2
        else
        @message = "Sorry but #{@word} does not seen to be a valid English word."
      end
    else
      @message = "#{@word} is not a valid word for this grid"
    end
    session[:score] += @result
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def included?(word, letters)
    word.chars.all? { |letter| letters.count(letter) >= word.count(letter)}
  end
end
