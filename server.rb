require_relative 'rgz'
require 'socket'
require 'rack'

class App
  def call(env)
    req = Rack::Request.new(env)
    params = env["QUERY_PARAMS"]

    atm = CashMachine.new("$")

    case req.path
    when "/withdraw"
      if params.nil? || params["value"].nil?
        [402, { "Content-Type" => "text/html" }, ["Withdraw value is not represented"]]
      elsif atm.withdraw(params["value"]) == 0
        [200, { "Content-Type" => "text/html" }, ["You have withdrawn #{params["value"]}#{atm.currency}"]]
      else
        [403, { "Content-Type" => "text/html" }, ["Incorrect value"]]
      end

    when "/deposit"
      if params.nil? || params["value"].nil?
        [401, { "Content-Type" => "text/html" }, ["Deposit value is not represented"]]
      elsif atm.deposit(params["value"]) == 0
        [200, { "Content-Type" => "text/html" }, ["You deposited #{params["value"]}#{atm.currency}"]]
      else
        [403, { "Content-Type" => "text/html" }, ["Incorrect value"]]
      end

    when "/balance"
      [200, { "Content-Type" => "text/html" }, [atm.balanceInfo]]

    else
      [404, { "Content-Type" => "text/html" }, ["Not Found this page"]]
    end
  end
end

def array_transform(array)
  result = {}
  array.each do |item|
    str = item.split("=")
    key = str[0]
    value = str[1]
    result[key] = value
  end
  result
end

server = TCPServer.new('127.0.0.1', 7880)

app = App.new

while connection = server.accept
  request = connection.gets
  method, full_path, http_version = request.split(' ')
  path, params = full_path.split('?')
  status, headers, body = app.call(
    {
       'REQUEST_METHOD' => method,
       'PATH_INFO' => path,
       'QUERY_PARAMS' => params != nil ? array_transform(params.split('&')) : nil
    })

  connection.print "#{http_version} #{status} \r\n"

  headers.each do |key, value|
    connection.print "#{key}: #{value}\r\n"
  end
  connection.print "\r\n"

  body.each do |part|
    connection.print part
  end

  connection.close
end