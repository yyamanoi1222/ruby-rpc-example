require './app'
require './handler'

h = Handler.new
run XmlRPCApp.new(h)
