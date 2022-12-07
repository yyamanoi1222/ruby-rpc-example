require "jimson"

resp = Jimson::Client.new("localhost:8999").say_hello("Bob")
p resp
