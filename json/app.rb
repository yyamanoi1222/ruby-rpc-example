require 'json'

class JsonRPCApp
  def initialize(handler)
    @handler = handler
  end

  def call(env)
    req = Rack::Request.new(env)
    method, params, id = parse_req(req)
    body = dispatch(method, *params)
    build_response(body, id)
  end

  private

  def dispatch(method, params)
    @handler.send(method, params)
  end

  def parse_req(req)
    raise if req.env['CONTENT_TYPE'] != 'application/json'

    input = JSON.parse(req.env['rack.input'].read)
    raise if input['jsonrpc'] != '2.0'
    raise unless input.key?("method")
    raise unless input.key?("id")

    [input['method'], input.fetch('params', []), input['id']]
  rescue JSON::ParserError
    raise ArgumentError
  end

  def build_response(body, id)
    b = {
      jsonrpc: "2.0",
      result: body,
      id: id,
    }
    [200, {}, [b.to_json]]
  end
end
