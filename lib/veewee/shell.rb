#require 'open4'

module Veewee
  class Shell
 
    def self.execute(command,options = {})
      puts command
      print IO.popen("#{command}").readlines
    end
    
    #pty allows you to gradually see the output of a local command
    #http://www.shanison.com/?p=415
      def self.execute2(command, options = {} )
        require "pty"
            begin
              PTY.spawn( command ) do |r, w, pid|
                begin
                  r.each { }      
                  #r.each { |line| print line;}      

               rescue Errno::EIO        
               end      
             end  
           rescue PTY::ChildExited => e
              puts "The child process exited!"
           end
      end

      #occassinally fails with 'no child processes
      def self.execute3(command, options = {} )
        defaults= { :port => "22", :exitcode => "0", :user => "root"}
          options=defaults.merge(options) 

          status = POpen4::popen4(command) do |stdout,stderr,stdin|
            stdout.each do |line|
              puts line
            end
          end
          
        @status=status.to_i
  
        if (@status.to_s != options[:exitcode] )
          if (options[:exitcode]=="*")
            #its a test so we don't need to worry
          else
            raise "Exitcode was not what we expected"
          end

        end

      end

  end #Class
end #Module
