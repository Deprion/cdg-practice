def greeting
    puts "Enter ur name"
    name = gets.chomp
    puts "Enter ur second name"
    sName = gets.chomp
    puts "Enter ur age"
    age = gets.to_i
    if age < 18
        puts "Привет, #{name} #{sName}. Тебе меньше 18 лет, но начать " +
        "учиться программировать никогда не рано."
    else
        puts "Привет, #{name} #{sName}. Самое время заняться делом!"
    end
end

def foobar(nums)
    if nums[0] == 20 || nums[1] == 20
        puts nums[1]
    else
        puts nums[0] + nums[1]
    end
end

foobar([10, 25])