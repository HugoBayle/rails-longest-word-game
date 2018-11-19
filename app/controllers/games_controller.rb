require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    url = 'https://wagon-dictionary.herokuapp.com/' + params[:word]
    word = open(url).read
    word_verification = JSON.parse(word)
    if word_verification['found'] == false
      @result = {message: "Sorry but #{params[:word].upcase} doesn't seem to be a valid English word...", score: 0}
    elsif word_verification['found'] == true && (params[:word].upcase.chars.all? { |letter| params[:word].upcase.count(letter) <= params[:letters].count(letter) }) == false
      @result = {message: "Sorry but #{params[:word].upcase} can't be built out of #{params[:letters]}", score: 0}
    else
      @result = {message: "Congratulations! #{params[:word].upcase} is a valid English word!", score: params[:word].length}
    end

    if session[:score] == nil
      session[:score] = @result[:score]
    else
      session[:score] += @result[:score]
    end
  end
end
