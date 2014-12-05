require 'socket'
require 'encrypted_strings' 

  port = 19998
  server = TCPServer.open(port)
  
  users = Hash.new
  users["lawlorni"] = "adsklj"
  users["niamh"] = "ghghgh"
  users["gary"] = "ruby"
  users["louise"] = "loulou"
  users["charlie"] = "chicken"

  sessionKeys = Hash.new
  serverEncryptionKey="123456789"

  fileServerEncryptionKey = 9999;


 def encrypt(password,data)
  encrypted = data.encrypt(:symmetric, :algorithm => 'des-ecb', :password => password)
   return encrypted
end

 def decrypt(encrypted,password)
      decrypted =encrypted.decrypt(:symmetric, :algorithm => 'des-ecb', :password => password)
      return decrypted
  end
  
loop{
      Thread.start(server.accept) do |client|
        #get username from client 

        username = client.gets
        username = username[0,username.length-1]
        puts username

       if username[0..5]=="CREATE"
        puts "got here"
          @user = username.split(" ")
          @name=@user[0]
          @name=@name[7,@name.length]
          @pass=@user[1]
          puts @name
          puts @pass

           if users[@name]
              puts "User already exists"
            else
                users[@name]=@pass
                puts "user created please login"
            end

        end

        request = client.gets
        request = request[0,request.length-1]

        #key to decrypt data received
        pass = users[username]
    
      
       unencryptedMessage=decrypt(request,pass)
       puts unencryptedMessage


        

        if unencryptedMessage.include? "LOGIN"
      
         #generate random session key
          randy = rand(1238783)
          sessionKeys[username] = randy #store session key with username
         
          
          sessionKey= randy.to_s
          #encrypt the ticket with the serverEncryptionKey
          ticket = encrypt(sessionKey,serverEncryptionKey)

          #create token
          token = Array.new(3)
          token[0] = encrypt(pass,sessionKey)
          token[1] = encrypt(pass,ticket)
          token[2] = encrypt(pass,"FileSystem")
          system=token[2].length
          
           #send token to client
          client.puts token[0]
          client.puts token[1]
          client.puts token[2]
         
          client.close

        end
      

        #send back token

      end
      }

