#client socket program that sends string to server through socket
#and displays returned modified string
require 'encrypted_strings'
require 'socket'      # Sockets are in standard library


hostname = 'localhost'
securityServerPort = 19998
fileServerPort=19999
dirLocation ="/Users/lawlorni/Desktop/College/DistributedSystems/Labs/FinalProj/ClientFiles/"


def encrypt(password,data)
  encrypted = data.encrypt(:symmetric, :algorithm => 'des-ecb', :password => password)
   return encrypted
end

 def decrypt(encrypted,password)
      decrypted =encrypted.decrypt(:symmetric, :algorithm => 'des-ecb', :password => password)
      return decrypted
  end


users = Hash.new
users["lawlorni"] = "abc123"
users["niamh"] = "happy"
users["gary"] = "ruby"
users["louise"] = "loulou"
users["charlie"] = "chicken"
sessionKey="0"

loop{

puts "Enter sentence"
message = gets
message = message[0,message.length-1]

  if message[0..4]=="LOGIN"

        securitySocket = TCPSocket.open(hostname, securityServerPort) #create socket

        puts "Password:"
        password=gets
        password=password[0,password.length-1]  #ignore \n added to sentence

        #encrypt request to be sent to server
        request=encrypt(password,message)

        #get user and send to auth server
        message.slice! "LOGIN:"
        securitySocket.puts message #send username to server

        #send request
        securitySocket.puts request

        #receive token from auth server
        token =Array.new(3)
        token[0] = securitySocket.gets
        token[1] = securitySocket.gets
        token[2] = securitySocket.gets


        sessionKey=decrypt(token[0],password)
        encryptedTicket=decrypt(token[1],password)
        server = decrypt(token[2],password)
        #display values received in token
        puts "\nSession Key : #{sessionKey}\nTicket : #{encryptedTicket}Server : #{server}\n"

  

elsif message[0..3] =="READ"
    if sessionKey=="0"  #if not logged in
      puts "You are not logged in or your session has expired. Please log in using LOGIN:username command"
    
    else #if logged in
      file=message[5,message.length]
      fileSocket= TCPSocket.open(hostname, fileServerPort) #create socket    
      destFile=File.open(dirLocation+message[5,message.length],"w+")
      puts message
      fileSocket.puts message

      data=fileSocket.read
      puts data
      destFile.print data

      destFile.close
   end

elsif message[0..4] =="WRITE"
    if sessionKey=="0"  #if not logged in
      puts "You are not logged in or your session has expired. Please log in using LOGIN:username command"
    
    else #if logged in
      
      file=message[6,message.length]
      fileSocket= TCPSocket.open(hostname, fileServerPort) #create socket    
      destFile=File.open(dirLocation+file,"w+")
      puts "EDIT:"
      edit=gets
      
      message[0..5]="READ:"
      puts message
      fileSocket.puts message

  
      data=fileSocket.read
      puts data
      destFile.print data
      destFile.print edit
       destFile.close

       fileSocket= TCPSocket.open(hostname, fileServerPort)
       sendFile=open(dirLocation+file,"rb")
       sendContent=sendFile.read
       message[0..4]="SEND:"
       fileSocket.puts message
       puts "message should have #{message}"
       fileSocket.puts(sendContent)
       fileSocket.close
       sendFile.close
   end
 else
    fileSocket= TCPSocket.open(hostname, fileServerPort) #create socket  
    fileSocket.puts message

end

}


  

    
