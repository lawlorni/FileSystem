require 'socket'
require 'encrypted_strings'

class ClientProxy
  def initialize(hostname,filePort,securityPort)
    @hostname=hostname
    @securityPort=securityPort
    @filePort=filePort
    @users=Hash.new
    @users["lawlorni"] = "abc123"
    @users["niamh"] = "happy"
    @users["siobhan"] = "ruby"
    @users["kurt"] = "nomad"
    @users["ana"] = "djaklsdj"
    @sessionKey="0"
    @dirLocation ="/Users/lawlorni/Desktop/College/DistributedSystems/Labs/FinalProj/ClientFiles/"
  end

 def encrypt(password,data)
  encrypted = data.encrypt(:symmetric, :algorithm => 'des-ecb', :password => password)
   return encrypted
  end

 def decrypt(encrypted,password)
      decrypted =encrypted.decrypt(:symmetric, :algorithm => 'des-ecb', :password => password)
      return decrypted
  end

def read(message)
    @fileSocket=TCPSocket.open(@hostname,@filePort)
    @destFile=File.open(@dirLocation+message[5,message.length],"w+")
    @fileSocket.puts message
    @data=@fileSocket.read
    puts @data
    @destFile.print @data
    @destFile.close
end

  def login(message)
      @log = message.split(' ')
      @username=@log[0]
      @username=@username[6,@username.length]
      @securitySocket=TCPSocket.open(@hostname,@securityPort)
      @securitySocket.puts @username
      @securitySocket.puts encrypt(@log[1],@log[0])
      @token=Array.new(3)
      @token[0] = @securitySocket.gets
      @token[1] = @securitySocket.gets
      @token[2] = @securitySocket.gets
      @sessionKey=decrypt(@token[0],@log[1])
      @encryptedTicket=decrypt(@token[1],@log[1])
      @server = decrypt(@token[2],@log[1])
        #display values received in token
      puts "\nSession Key : #{@sessionKey}\nTicket : #{@encryptedTicket}Server : #{@server}\n"
  end

 def write(message)
    puts "EDIT:"
    @edit=gets
    @file=message[6,message.length]
    @fileSocket=TCPSocket.open(@hostname,@filePort)
    @destFile=File.open(@dirLocation+message[6,message.length],"w+")
    message[0..5]="READ:"
    @fileSocket.puts message
    @data=@fileSocket.read
    puts @data
    @destFile.print @data
    @destFile.print @edit
    @destFile.close
    @fileSocket= TCPSocket.open(@hostname, @filePort)
    @sendFile=open(@dirLocation+@file,"rb")
    @sendContent=@sendFile.read
    message[0..4]="SEND:"
    @fileSocket.puts message
       puts "message should have #{message}"
    @fileSocket.puts(@sendContent)
    @fileSocket.close
    @sendFile.close
 end

 def create(message)
  @fileSocket=TCPSocket.open(@hostname,@securityPort)
  @fileSocket.puts message
  @identity=message.split(" ")
  @pass=@identity[1]
  @user=@identity[0]
  @user=@user[7,@user.length]

  if @users[@user]
    puts "User already exists"
  else
      @users[@user]=@pass
      puts "user created please login"
  end
 
 end

  def go
    loop{
  puts "Enter sentence"
  @message=gets
  @message=@message[0,@message.length-1]

  if @message[0..4]=="LOGIN"
    login(@message)
  elsif @message[0..3]=="READ"
    if @sessionKey=="0"
        puts "Please log in"
      else
        read(@message)
      end
  elsif @message[0..4]=="WRITE"
    write(@message)
  elsif @message[0..5]=="CREATE"
    create(@message)
     end
 }
  end
end  #end of client proxy class

  aClientProxy=ClientProxy.new('localhost',19999,19998)
  aClientProxy.go




