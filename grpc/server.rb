require 'grpc'
require './proto/hello_services_pb'

class HelloServer < Helloworld::Greeter::Service
  def say_hello
  end
end

def serve
  server = GRPC::RpcServer.new
  server.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  server.handle(HelloServer)
  server.run_till_terminated_or_interrupted([1, 'int', 'SIGTERM'])
end

serve
