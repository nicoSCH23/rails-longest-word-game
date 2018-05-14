require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    session[:player_1] = params[:player_1] unless session[:player_1]
    session[:player_2] = params[:player_2] unless session[:player_2]
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    session[:score] = 0 unless session[:score]
    session[:score_2] = 0 unless session[:score_2]
  end

  def score
    @result = 0
    @result_2 = 0
    @letters = params[:letters].split(' ')
    @word = params[:word]
    @word_2 = params[:word_2]
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
    if included?(@word_2, @letters)
      if english_word?(@word_2)
        @message_2 = "Congratulations, #{@word_2.upcase} is a valid English word!"
        @result_2 += @word_2.length**2
        else
        @message_2 = "Sorry but #{@word_2} does not seen to be a valid English word."
      end
    else
      @message_2 = "#{@word_2} is not a valid word for this grid"
    end
    session[:score] += @result
    session[:score_2] += @result_2
  end

  def start
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
