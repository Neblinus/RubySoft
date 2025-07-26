# Count occurrences of user-inputted words on inputted text
# Made by Neblinus using Ruby 3.2.0

# Message to get the dictionary (words of interest on texts)
def get_words_of_interest
	words_input_method = ""
  puts "Time to enter the words to be counted on text."
  # Request the user to decide between file or manually typed input
  until words_input_method == "f" or words_input_method == "m"
    print "Enter 'f' for file input or 'm' for manual input [f/m]: "
    words_input_method = gets.chomp
  end
  words_to_be_counted = case words_input_method
    # For file input, request the file path and read the file
    when "f"
      puts "Remember that each word must be on a separate line."
      print "Enter the path for the file: "
      File.read(gets.chomp)
    # For manually typed input, request each word to be separated with " "
    when "m"
      puts "Remember to type each word separated by a space."
      print "Enter the words: "
      gets.chomp
  end
	words_to_be_counted
end

# Method to get the text on which words will be counted
def get_text_to_count_words
  puts "Time to enter the text on which words will be counted."
  # Request the desired input method from user
  text_input_method = ""
  until text_input_method == "f" || "m"
end

# Message to check if a given word of the text contains a word from the list
def get_words_count(words_list, text_words)
  words_count_hash = Hash.new
  # Loop through each word of the user-inputted text
  text_words.each do |text_word|    
    # Loop through each word of the defined list
    words_list.each do |list_word|
      # Check whether the current word contains one of the list words, using
      # them on upcase for case-insensitive comparision
      case text_word.upcase.include?(list_word.upcase)
        # Skip words that don't include the list word
        when false then next
        # Add words that include the list word
        else
          current_word_count = words_count_hash.fetch(list_word, 0)
          words_count_hash.store(list_word, current_word_count + 1)
      end
    end
  end
  words_count_hash
end

# Message to print the words count information on a more readable format
def print_count_information(count_hash)
  count_hash.each_pair do |key, value|
    puts "Number of '#{key}' occurrences: #{value}"
  end
end

# Main
keep_running = ""
until keep_running == "n" do
  words_of_interest = get_words_of_interest
  input_text = get_text_to_count_words
  # Use the input as word-per-word array for easier manipulation
  words_count = get_words_count(words_of_interest.split, input_text.split)
  print_count_information(words_count)
  puts "Do you want to check another words on another text?"
  print "Type any character different from 'n' to continue: "
  keep_running = gets.chomp
end
