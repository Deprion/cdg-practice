def end_with_cs
    puts "Input a word"
    input_word = gets.chomp.to_s
    if input_word[-2, 2] == "cs"
      puts 2**input_word.length
    else
      puts input_word.reverse
    end
  end
  
  def pokemons
    arr = {}
    puts "How many add?"
    count = gets.to_i
    count.times do
      puts "Name of pokemon"
      name = gets.chomp.to_s
      puts "Color of pokemon"
      color = gets.chomp.to_s
      arr[name] = color
    end
    arr.each_pair {
      |key, value| puts "name: '#{key}', color: '#{value}'"
    }
  end