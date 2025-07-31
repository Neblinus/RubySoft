# Count occurrences of user-inputted words on inputted text
# Made by Neblinus using Ruby 3.2.0

# Method to get the dictionary (words of interest on texts)
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
      get_valid_file_content
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
  until text_input_method == "f" or text_input_method == "m"
    print "Enter 'f' for file input or 'm' for manual input [f/m]: "
    text_input_method = gets.chomp
  end
  # Get the text on which words will be counted
  text_to_count_words = case text_input_method
    # For file input
    when "f"
      get_valid_file_content
    # For manual input
    when "m"
      print "Enter the text: "
      gets.chomp
  end
  text_to_count_words
end

# Method to check if a given word of the text contains a word from the list
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

# Method to perform the desired output method from user
def perform_output_method(hash_count_words)
  # Request output method
  puts "Time to define the output method."
  output_method = ""
  until output_method == "f" or output_method == "c"
    print "Enter 'f' for file output or 'c' for console output [f/c]: "
    output_method = gets.chomp
  end
  # Output the words count using the desired method
  case output_method
    # For file output
    when "f"
      output_path = get_valid_output_file
      output_file = File.new(output_path, "w")
      print_count_information(hash_count_words, output_file, output_method)
      puts "All words count written to the file."
    # For console output
    when "c"
      puts "Words occurrences: "
      print_count_information(hash_count_words, output_method)
  end
end

# Method to print the words count information based on the selected output
# method; hence, the supply of an argument for the out_file parameter is
# optional (in case the user wants to print information to the console)
def print_count_information(count_hash, *out_file, desired_output_method)
  count_hash.each_pair do |key, value|
    # Define where to print the output based on the desired output method
    case desired_output_method
      # For file output
      when "f"    
        # Write the count hash information on the file
        information = "Number of '#{key}' occurrences: #{value}\n"
        # As an optional parameter, out_file has an Array type
        File.write(out_file.first, information, mode: "a")
      # For console output
      when "c"
        # Write the count hash information to the console
        puts "Number of '#{key}' occurrences: #{value}"
    end
  end
end

# Method to get the content of valid files
def get_valid_file_content
  # Loop until user has given a valid file
  is_valid_file = false
  file_path = ""
  until is_valid_file do
    print "Enter the absolute path to the .txt file: "
    file_path = gets.chomp
    file_exist = File.exist?(file_path)
    file_readable = File.readable?(file_path)
    is_txt = File.extname(file_path) == ".txt"
    # Check if file is valid; if not, give meaningful information
    if file_exist and file_readable and is_txt
      is_valid_file = true
    elsif not file_exist
      puts "This file doesn't exist under this path.\nCheck the path."
    elsif not file_readable
      puts "The OS can't read this file contents."
    elsif not is_txt
      puts "This file isn't a .txt one.\nCheck the file extension."
    end
  end
  # Read the file and return its contents
  File.read(file_path)
end

# Method to get valid output file path
def get_valid_output_file
  output_file_path = ""
  is_valid_path = false
  # Loop until user has given a valid file path for output
  until is_valid_path do
    print "Enter the absolute path to store the output .txt file: "
    output_file_path = gets.chomp
    is_absolute_path = File.absolute_path?(output_file_path)
    is_directory = File.directory?(output_file_path)
    is_valid_path = true if is_absolute_path and is_directory
  end
  # Add '/' ending to the path if it doesn't end on '/', in order to keep
  # the folder structure when adding the output file name
  output_file_path = output_file_path + "/" if output_file_path.chars.last != "/"
  output_file_path = output_file_path + "word_count.txt"
end

# Main
keep_running = ""
until keep_running == "n" do
  system "clear"
  words_of_interest = get_words_of_interest
  print "\n"
  input_text = get_text_to_count_words
  print "\n"
  # Use the input as word-per-word array for easier manipulation
  words_count = get_words_count(words_of_interest.split, input_text.split)
  # Perform the appropiate output method
  perform_output_method(words_count)
  print "\n"
  puts "Do you want to check another words on another text?"
  print "Type any character different from 'n' to continue: "
  keep_running = gets.chomp
end
