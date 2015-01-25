class WelcomeController < ApplicationController

  def index
    #Rails.logger.info("PARAMS: #{params.inspect}")
    #Rails.logger.info("Post: #{request.post?}")
  end

  def create
    text_to_parse = params[:textarea].downcase.split
    words_per_phrase = params[:phrase_size].to_i
    @freq = phrase_frequency(text_to_parse, words_per_phrase)  
    logger.info("freq #{@freq.inspect}")
    @x_axis = generate_x_axis(@freq)
    @y_axis = generate_y_axis(@freq)

    logger.info("X axis #{@x_axis.inspect}")
    logger.info("Y axis #{@y_axis.inspect}")
    respond_to do |format|
      format.js {} 
    end

  end

  private

  def phrase_frequency(text_arr, words_per_phrase)
    freq = {}
    # Convert text_to_parase into an array
    # and create a string for each phrase
    text_arr.each_cons(words_per_phrase) do |slice|

      str = ''
      slice.each do |s|
        str += s + ' '   
      end
      
      # trim all the white space in front and back of each phrase
      str.strip!
      
      # calculate word count
      if freq.has_key?(str) then freq[str] += 1 else freq[str] = 1 end

    end

    # sort the hash
    return freq = freq.sort_by { |word, count| count}.reverse
  end
  
  def generate_x_axis(freq)
    x_axis = Array.new()
    freq.each { |key, value| x_axis.push(key) }
    return arr_to_hc(x_axis)
  end

  def generate_y_axis(freq)
    y_axis = Array.new()
    freq.each { |key, value| y_axis.push(value) }
    return arr_to_hc(y_axis)
  end

  # For high charts we require a representation with single quotes such as ['A', 'B', 'C']
  # arr.to_s will return something like "[\"A\", \"B\"]"
  # We shall replace \" with ' n
  def arr_to_hc(arr)
    return arr.to_s.gsub("\"", "\'")
  end

end
