require './app'
require './handler'

h = Handler.new
run JsonRPCApp.new(h)
