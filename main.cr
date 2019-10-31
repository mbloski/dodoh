require "option_parser"
require "./console"
require "./dns"
require "./doh"
require "./dodoh"

bindhost = "127.0.0.1"
bindport = 5300
resolver = "https://cloudflare-dns.com"

begin
  OptionParser.parse { |x|
    x.on("-h", "--help", "Show this help") {
      puts x
      exit 0
    }
    x.on("-H HOST", "--host HOST", "DNS bind host") { |host| bindhost = host }
    x.on("-p PORT", "--port PORT", "DNS bind port") { |port| bindport = port }
    x.on("-r URL", "--resolver URL", "URL of the DoH resolver") { |_resolver| resolver = _resolver }
  }
rescue ex : OptionParser::InvalidOption | OptionParser::MissingOption
  Console.error(ex.to_s, true)
end

Console.info "    |         |     |    "
Console.info ",---|,---.,---|,---.|---.  DNS <-> DoH proxy"
Console.info "|   ||   ||   ||   ||   |  michael@blo.ski"
Console.info "`---'`---'`---'`---''   '"
Console.info ""
begin
  server = DODOH.new bindhost, bindport.to_i, resolver
  server.run
rescue ex : ArgumentError
  Console.error(ex.to_s, true)
end
