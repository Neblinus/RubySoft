# Caesar cipher/decipher implementation using right shift
# Made by Neblinus using Ruby 3.2.0

# Methods implementations

# Request user input
def request_user_input
  desired_action = ""
  until ["c", "d", "e"].include?(desired_action) do
    print "What do you want to do [c - cipher/d - decipher/e - exit]? "
    desired_action = gets.chomp
  end
  # Avoid repetition of print statements
  print "Insert the text: "
  case desired_action
    # Common actions for both ciphering and deciphering
    when "c", "d"
      user_text = gets.chomp
      valid_shifting_factor = get_valid_shifting_factor
      return user_text, valid_shifting_factor, desired_action
    # When user wants to exit
    else
      desired_action
  end
end

# Get a valid shifting factor from the user
def get_valid_shifting_factor
  raw_shifting_factor = ""
  has_non_digit_char = /\D/.match?(raw_shifting_factor)
  # Ask the user for input
  loop do
    print "Insert the shifting factor [any positive integer]: "
    raw_shifting_factor = gets.chomp
    break if not has_non_digit_char
  end
  raw_shifting_factor.to_i
end

# Performs ciphering algorithm
def perform_caesar_ciphering(original_input)
  # Regex used for easily identifying if a char is number, letter or else
  alphabet_regex = /[a-zA-Z]/
  numbers_regex = /[0-9]/
  # Use input as uppercase char-per-char array for easier manipulation
  input_chars = original_input.upcase.split("")
  ciphered_output = Array.new(input_chars.length)
  # Loop through the unciphered chars getting the ciphered analog
  input_chars.each_with_index do |current_char, current_char_index|
    # If the current char is a letter
    if alphabet_regex.match?(current_char)
      ciphered_output[current_char_index] = cipher_letters(current_char)
    # If the current char is a number
    elsif numbers_regex.match?(current_char)
      ciphered_output[current_char_index] = cipher_numbers(current_char.to_i)
    # If the current char is anything else
    else
      ciphered_output[current_char_index] = current_char
    end
  end
  ciphered_output
end

# Cipher alphabetic chars
def cipher_letters(original_letter)
  ciphered_char = ""
  alphabet_letters = ("A".."Z").to_a
  # The loop must start at the location of the current original char
  letter_index = alphabet_letters.find_index(original_letter)
  # Loop through the letters array until the ciphered analog is found
  $SHIFTING_FACTOR.times do
    # When the loop reaches the last char, it must set the index to start
    # the next iteration on the first letter again
    unless alphabet_letters.fetch(letter_index) == alphabet_letters.last
      letter_index = letter_index + 1
    else
      letter_index = alphabet_letters.find_index(alphabet_letters.first)
    end
    ciphered_char = alphabet_letters.fetch(letter_index)
  end
  ciphered_char
end

# Cipher numeric chars
def cipher_numbers(original_digit)
  ciphered_digit = 0
  valid_digits = (0..9).to_a
  # The digit index must be set to start the loop at the position of the
  # current ciphered digit
  digit_index = valid_digits.find_index(original_digit)
  # Loop through the digits array until the ciphered analog digit is found
  $SHIFTING_FACTOR.times do
    # When the loop reaches the last element of the array, the digit_index
    # must be set to the first element index, to restart the cycle
    unless valid_digits.fetch(digit_index) == valid_digits.last
      digit_index = digit_index + 1
    else
      digit_index = valid_digits.find_index(valid_digits.first)
    end
    ciphered_digit = valid_digits.fetch(digit_index)
  end
  ciphered_digit.to_s
end

# Performs deciphering algorithm
def perform_caesar_deciphering(text_to_be_deciphered)
  # Regex used for easily identifying if a char is number, letter or else
  letters_regex = /[a-zA-Z]/
  digits_regex = /[0-9]/
  # Use input as uppercase char-per-char array for easier manipulation
  ciphered_chars = text_to_be_deciphered.upcase.split("")
  unciphered_chars = Array.new(ciphered_chars.length)
  # Loop through the ciphered chars getting the deciphered analog
  ciphered_chars.each_with_index do |current_char, current_char_index|
    # If the current char is a letter
    if letters_regex.match?(current_char)
      unciphered_chars[current_char_index] = decipher_letters(current_char)
    # If the current char is a number
    elsif digits_regex.match?(current_char)
      unciphered_chars[current_char_index] = decipher_numbers(current_char.to_i)
    # If the current char is any other thing (puntuaction, etc)
    else
      unciphered_chars[current_char_index] = current_char
    end
  end
  unciphered_chars
end

# Decipher alphabetic chars
def decipher_letters(current_char)
  deciphered_char = ""
  reversed_alphabet = ("A".."Z").reverse_each.to_a
  # The loop must start at the location of the current ciphered char
  letter_index = reversed_alphabet.find_index(current_char)
  # Loop through the reversed letters array until the unciphered analog
  # char is found
  $SHIFTING_FACTOR.times do
    # When the loop reaches the last char, it must set the index to start
    # the next iteration on the first letter again
    unless reversed_alphabet.fetch(letter_index) == reversed_alphabet.last
      letter_index = letter_index + 1
    else
      letter_index = reversed_alphabet.find_index(reversed_alphabet.first)
    end
    deciphered_char = reversed_alphabet.fetch(letter_index)
  end
  deciphered_char
end

# Decipher numeric chars
def decipher_numbers(current_digit)
  deciphered_digit = 0
  reversed_digits = (0..9).reverse_each.to_a
  # The digit index must be set to start the loop at the position of the
  # current ciphered digit
  digit_index = reversed_digits.find_index(current_digit)
  # Loop through the reversed digits array until the deciphered analog
  # digit is found
  $SHIFTING_FACTOR.times do
    # When the loop reaches the last element of the array, the digit_index
    # must be set to the first element index, to restart the cycle
    unless reversed_digits.fetch(digit_index) == reversed_digits.last
      digit_index = digit_index + 1
    else
      digit_index = reversed_digits.find_index(reversed_digits.first)
    end
    deciphered_digit = reversed_digits.fetch(digit_index)
  end
  deciphered_digit.to_s
end

# Convert the ciphered/deciphered string to its original case
def adjust_to_original_case(uppercase_chars, original_string)
  original_chars = original_string.split("")
  correct_case_chars = Array.new(original_chars.length)
  uppercase_alphabet = /[A-Z]/
  # Loop through the original unciphered string, checking if the ciphered
  # analog has different case and performing the needed tweaks
  original_chars.each_with_index do |current_char, current_char_index|
    # Unless the current original char is uppercase
    unless uppercase_alphabet.match?(current_char)
      correct_case_chars[current_char_index] = uppercase_chars[current_char_index].downcase
    else
      correct_case_chars[current_char_index] = uppercase_chars[current_char_index]
    end
  end
  correct_case_chars.join
end

# Main
keep_running = "y"
until keep_running == "n" do
  system 'clear'
  # Get user input as an array with the text, the shifting factor and the
  # desired action for the program to perform
  user_input = request_user_input
  # Use the shifting factor as global variable, avoiding repetitively
  # passing it as argument
  $SHIFTING_FACTOR = user_input[1]
  # Call the adequate deciphering/ciphering algorithm and output its result
  case user_input.last
    # For ciphering text
    when "c"
      ciphered_text = perform_caesar_ciphering(user_input.first)
      puts "Ciphered text: #{adjust_to_original_case(ciphered_text, user_input.first)}"
    # For deciphering text
    when "d"
      deciphered_text = perform_caesar_deciphering(user_input.first)
      puts "Deciphered text: #{adjust_to_original_case(deciphered_text, user_input.first)}"
    # For exiting program
    else
      exit(0)
  end
  # Confirmation to keep running
  puts "Do you want to perform another action? "
  print "[Type 'n' for exiting/type any other char to continue]: "
  keep_running = gets.chomp
end
