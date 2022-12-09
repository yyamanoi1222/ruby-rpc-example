require 'rexml/document'

class XmlRPCApp
  def initialize(handler)
    @handler = handler
  end

  def call(env)
    req = Rack::Request.new(env)
    method, params = parse_req(req)
    body = dispatch(method, *params)
    build_response(body)
  end

  private

  def dispatch(method, params)
    @handler.send(method, params)
  end

  def parse_req(req)
    raise if req.env['CONTENT_TYPE'] != 'text/xml'

    doc = REXML::Document.new(req.env['rack.input'].read)
    method = doc.elements['methodCall/methodName'].text
    params = [].tap do |pa|
      doc.elements['methodCall/params'].each do |e|
        if e.is_a? REXML::Element
          pa << e.elements['value'].text
        end
      end
    end
    [method, params]
  end

  def build_response(body)

    b = <<-EOF
    <?xml version="1.0"?>
    <methodResponse>
      <params>
        <param>
          <value><string>#{body}</string></value>
        </param>
      </params>
    </methodResponse>
    EOF
    [200, {  "content-type" => "text/xml" }, [b]]
  end
end
