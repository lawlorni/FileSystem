#client socket program that sends string to server through socket
#and displays returned modified string

require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 19999
s = TCPSocket.open(hostname, port) #create socket
 
  #destFile = File.open("/Users/lawlorni/Desktop/College/DistributedSystems/Labs/FinalProj/ClientFiles/server.txt","wb")
   location ="/Users/lawlorni/Desktop/College/DistributedSystems/Labs/FinalProj/ClientFiles/"
   eofTransmission = "end\n"  #end to signify end of transmission

loop{
  puts "Enter command"
  sentence = gets
  

if sentence.include? "DOWNLOAD"
  s.puts sentence
  sentence.slice! "DOWNLOAD:"
  fileName=sentence[0,sentence.length-1]
  destFile = File.open(location+fileName,"w+")
  ans = "no"
  bool =1
  
  while(bool>0)
    ans = s.gets
      if(ans!=eofTransmission)
      puts ans
  		destFile.print ans
		  
    else
      bool=0
    end
	end 
  destFile.close

	end

  if sentence.include? "LIST"
  s.puts sentence
  ans = "no"
  while (ans!=eofTransmission)
  		ans = s.gets
		  puts ans
	end 
 end

 if sentence.include? "UPLOAD"
  s.puts sentence
  sentence.slice! "UPLOAD:"
  fileName=sentence[0,sentence.length-1]
  file=open(location+fileName,"rb")
  fileContent=file.read
  s.puts(fileContent)
  s.puts("end")

end
}
destFile.close

    
