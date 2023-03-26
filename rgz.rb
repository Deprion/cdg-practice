class CashMachine
  attr_reader :currency
  StartBalance = 100.0
    
  def initialize(currency)
    @currency = currency
    @balancePath = File.join(File.dirname(__FILE__), "balance.txt")

    if File.file?(@balancePath)
      @balance = File.read(@balancePath).to_f
    else
      File.write(@balancePath, StartBalance, mode: "w")
      @balance = StartBalance
    end
  end
  
  def deposit(amount)
    amount = amount.to_f
    if amount > 0.0
      @balance += amount

      save
      0
    else
      -1
    end
  end

  def withdraw(amount)
    amount = amount.to_f
    if amount > 0.0 && @balance >= amount 
      @balance -= amount

      save
      0
    else
      -1
    end
  end

  def balanceInfo
    "Balance = #{@balance}#{@currency}"
  end

  def save
    File.write(@balancePath, @balance)
  end
end