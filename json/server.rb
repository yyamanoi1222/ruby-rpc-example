require 'jimson'

class HelloWorld
  extend Jimson::Handler

  def say_hello(name)
    "hellow world #{name}"
  end
end

server = Jimson::Server.new(HelloWorld.new)
server.start
