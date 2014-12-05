require 'socket' 

 
  port = 19999
  server = TCPServer.open(port)

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
          loop{
        read = client.gets
        
        read=read[0,read.length-1]
        puts read
        
        location = "/Users/lawlorni/Desktop/College/DistributedSystems/Labs/FinalProj/ServerFiles/"
         same = "download.txt"
         eofTransmission = "end\n"

      if read[0..5]=="CREATE"
          @user = read.split(" ")
          puts @user
          @username=@user[0]
          @username=@username[7,@username.length]
          puts @username
      end
        if read[0..3]=="READ"
            read=read[5,read.length]
            fileLocation=location+read
            puts fileLocation
            puts fileLocation.length
            file=open(fileLocation,"rb")
           # file.seek(3, IO::SEEK_END) 
            fileContent=file.read
            client.puts(fileContent)
            client.close
        end

        if read[0..3]=="SEND"
          file=read[5,read.length]
          l=location+file
          puts l
          puts l.length
          destFile=File.open(l,"w+")
          puts "got here"
          data=client.read
          puts "data receive is #{data} "
          destFile.puts data
          client.close
          destFile.close
        end

      if read.include? "DOWNLOAD"
          read.slice! "DOWNLOAD:"
          l=read.length
          sub=read[0,l-1]
          fileLocation=location+sub
          file = open(fileLocation,"rb")
          fileContent = file.read
          client.puts(fileContent)
          client.puts("end")   #key to signify end of transmission
     end

        if read.include? "LIST"
          client.puts Dir.entries("./ServerFiles/")
          client.puts("end")
        end

        if read.include? "UPLOAD"
              ans = "no"
              read.slice! "UPLOAD:"
              fileName=read[0,read.length-1]
              fileLocation=location+fileName
              receive=File.open(fileLocation,"wb")
              ans="no"
                  while(bool>0)
                      if(ans!=eofTransmission)
                          ans = s.gets
                          destFile.print ans
                          puts ans
                    else
                         bool=0
                    end
                  end         
         end 

      }
        end

      }


