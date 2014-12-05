require 'socket'


clientSocket=TCPSocket.open('localhost',19997)
@message=Array.new(2)
@message[0]= "yo"
@message[1]= "yoyoyipee"
clientSocket.write(@message)
clientSocket.close_write