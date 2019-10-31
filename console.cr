class Console
  def self.info(message : String | Nil)
    self.out("INFO", message)
  end

  def self.error(message : String | Nil, bailout = false)
    self.out("#{"#" * 10} ERROR", message, STDERR)
    exit 1 if bailout
  end

  def self.out(type : String, message : String | Nil, fd : IO::FileDescriptor = STDOUT)
    fd.puts "#{Time.local.to_s("%Y-%m-%d %T")} #{type.rjust(16, ' ')} | #{message}" if !message.nil?
  end
end
