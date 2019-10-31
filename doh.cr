require "http/client"
require "http/client"

class DOH
  def initialize(resolver : String)
    uri = URI.parse(resolver)
    @httpclient = HTTP::Client.new uri
    @headers = HTTP::Headers.new
    ["accept", "content-type"].each { |x| @headers.add(x, "application/dns-message") }

    Console.info "Using #{resolver}"
  end

  def query(query : DNSQuery)
    response = @httpclient.post("/dns-query", @headers, body: query.to_s)
    response.body || nil
  end
end
