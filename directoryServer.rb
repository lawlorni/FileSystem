require 'socket'
require 'encrypted_strings' 

 
  @port=19997
  @server=TCPServer.open(@port)
  puts "did something"
  Thread.start(@server.accept) do |client|
    @message=Array.new(2)
    @message=client.gets
    puts "did something"
    puts @message
    end
 

