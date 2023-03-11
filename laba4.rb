PATH = File.join(File.dirname(__FILE__), "test.txt")
BUFFER = File.join(File.dirname(__FILE__), "buffer.txt")
BALANCE = File.join(File.dirname(__FILE__), "balance.txt")
STUDENTS = File.join(File.dirname(__FILE__), "students.txt")
RESULTS = File.join(File.dirname(__FILE__), "results.txt")

def index
    File.foreach(PATH) { |actor| puts actor }
end

def find(id)
    File.foreach(PATH).with_index { 
        |line, index|
        puts line if index == id
        }
end

def where(text)
    @ids = ""
    File.foreach(PATH).with_index do |line, index|
    @ids << index.to_s + ":" if line.include?(text)
end
    @ids
end

def update(id, text)
    file = File.open(BUFFER, 'w')
    File.foreach(PATH).with_index do |line, index|
    file.puts(id == index ? text : line)
    end
    file.close
    File.write(PATH, File.read(BUFFER))
    File.delete(BUFFER) if File.exist?(BUFFER)
end

def delete(id)
    file = File.open(BUFFER, 'w')
    File.foreach(PATH).with_index do |line, index|
    file << line unless index == id 
    end
    file.close
    File.write(PATH, File.read(BUFFER))
    File.delete(BUFFER) if File.exist?(BUFFER)
end

class CashMachine

    StartBalance = 100.0

    def initialize
      if File.file?(BALANCE)
        @balance = File.read(BALANCE).to_f
      else
        File.write(BALANCE, StartBalance, mode: "w")
        @balance = File.read(BALANCE).to_f
      end

      init
    end
  
    def deposit
      puts "How much to deposit?"
      amount = gets.to_f
      if amount > 0.0
        @balance +=  amount
        balance
      else
        puts "Incorrect amount"
      end
      File.write(BALANCE, @balance)
    end
  
    def withdraw
      puts "How much to withdraw?"
      amount = gets.to_f
      if @balance >= amount
        @balance -=  amount
        balance
      else
        puts "You don't have that much"
      end
      File.write(BALANCE, @balance)
    end
  
    def balance
      puts "Balance = #{@balance}"
    end
  
    def init
        loop do
            puts "Choose any: \nD - Deposit \nW - Withdraw \nB - Balance \nQ - Quit"
            input_command = gets.chomp.to_s
            case input_command
            when "D", "d"
                deposit
            when "W", "w"
                withdraw
            when "B", "b"
                balance
            when "Q", "q"
            break
            else
                puts "Command doesn't exist, try again"
            end
        end
  
    end
end

class Students

    def initialize
        init
    end

    def init
        if File.file?(STUDENTS)
            @studs = File.read(STUDENTS)
        end

        while true do
            if File.read(STUDENTS).length == 0 
                break
            end

            puts "Enter your age"
            age = gets.chomp.to_i
            
            search(age)
        end
    end

    def search(age)
        lines = []
        ids = []

        File.foreach(STUDENTS).with_index { 
            |line, index|
            if line.delete("^0-9").to_i == age
                lines << line
                ids << index
            end
            }

        if lines.length != 0
            write(lines)
        end

        ids.reverse.each do |id| delete(id)
        end
    end

    def write(lines)
        file = File.open(RESULTS, 'a')
        lines.each {
            |line|
            file.puts(line)
        }
        file.close
    end

    def delete(id)
        file = File.open(BUFFER, 'w')
        File.foreach(STUDENTS).with_index {
            |line, index|
            file << line unless index == id 
        }
        file.close
        File.write(STUDENTS, File.read(BUFFER))
        File.delete(BUFFER) if File.exist?(BUFFER)
    end
end