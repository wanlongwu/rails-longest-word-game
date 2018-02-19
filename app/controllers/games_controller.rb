require 'open-uri'
require 'json'


class GamesController < ApplicationController
  def new
    @test_array = []
    10.times do
      @test_array << ("a".."z").to_a.sample
    end
    @start_time = Time.new.iso8601
  end

  def score
    userhash = {}
    test_hash = {}
    user_word = params[:user_word]
    @test_array = params[:test_array].split(//)
    start_time = params[:start_time]
    user_word.split(//).each do |letter|
      if userhash[letter].nil?
        userhash[letter] = 1
      else
        userhash[letter] += 1
      end
    end

    @test_array.each do |letter|
      if test_hash[letter].nil?
        test_hash[letter] = 1
      else
        test_hash[letter] += 1
      end
    end

    userhash.each do |key, value|
      if test_hash[key] == nil
        @result = "you have to use valid letters of #{@test_array}"
      elsif test_hash[key] < value
        @result = "you can not use letters more than #{@test_array}"
      end
    end

    url = "https://wagon-dictionary.herokuapp.com/#{user_word}"
    user_serialized = open(url).read
    dictionary_result = JSON.parse(user_serialized)

    if dictionary_result["found"] == true
      @result = (dictionary_result["length"].to_i)/(Time.new - Time.parse(start_time)) * 1000
    else
      @result = "you have to input a legit word"
    end
  end
end
