require "socket"

class String
  def pretty_bytes
    self.bytes.to_a.map { |x| x.to_i }.join("_")
  end
end

class DODOH
  def initialize(host : String, port : Int, resolver : String)
    Console.info "Spawning server"

    @server = UDPSocket.new
    begin
      @server.bind host, port
    rescue ex : Errno | Socket::Addrinfo::Error
      Console.error(ex.to_s, true)
    end

    @doh = DOH.new resolver
    Console.info "Serving DNS at #{host}:#{port}"
  end

  def run
    loop {
      data = @server.receive
      next if data.nil?

      doproxy = ->(data : Tuple(String, Socket::IPAddress)) {
        spawn {
          source = data[1]
          response = DNSQuery.new data.first
          Console.out "DNSQuery", response.to_s.pretty_bytes
          dnsresponse = @doh.query response
          next if dnsresponse.nil?
          @server.send dnsresponse, source
          Console.out "DNSResponse", dnsresponse.pretty_bytes
        }
      }

      doproxy.call(data)
    }
  end
end
