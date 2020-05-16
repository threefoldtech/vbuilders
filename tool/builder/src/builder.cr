

require "json"

# res=`docker inspect --format='{{json .Config}}' builder_python`
# ipaddr=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' builder_python`.strip()
# res=`docker inspect builders_python`
# val=JSON.parse(res)

# macro docker_ip(name)
#   def {{name}}
#     `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' builder_python`.strip()
#   end
# end

require "ssh2"
require "earl"
require "../lib/earl/src/sock_server"

Earl::Logger.level = Earl::Logger::Severity::DEBUG


class EchoServer < Earl::SockServer
  def call(socket)
    while line = socket.gets
      socket.puts(line)

      # TCPServer and UNIXServer automatically flush on LF, but OpenSSL doesn't
      # socket.flush if socket.is_a?(OpenSSL::SSL::Socket::Server)
    end
  end
end

server = EchoServer.new
server.add_tcp_listener("::", 9292)

class PythonBuilder
  include Earl::Agent
  include Earl::Logger
  # include Earl::Mailbox(String)
  include Earl::Artist(String)
  @ipaddr = ""

  # def call(message : String)
  #   puts "client received=#{message}"
  #   # log.info [:string, message].inspect
  #   pp message
  # end  

  # def start
  #   pp "start"
  # end

  def call
    while running?
      ipaddr=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' builders_python`.strip()
      # pp ipaddr
      if ipaddr != @ipaddr
        log.info("ipaddr found #{ipaddr}")      
        @ipaddr = ipaddr
        # pp @ipaddr
      end
      if @ipaddr!=""
        #means the docker is active
        pp "ON"
      end
      sleep 2
      # raise "OH NO!"

    end    
  end

  def trap(agent, exception = nil)
    log.error("crashed with #{exception.message}") if exception
  end
end

pythonbuilder=PythonBuilder.new

Earl.application.monitor(pythonbuilder)
# Earl.application.monitor(server)

#start the apps
Earl.application.spawn

# sleep(1.seconds)

# pythonbuilder.send("TEST") 
# sleep(1.seconds)
# pythonbuilder.start

sleep(100.seconds)

# stop everything:
Earl.application.stop

# SSH2::Session.open("localhost",port=5001) do |session|
#   session.login_with_agent("root")
#   session.open_session do |channel|
#     channel.command("uptime")
#     IO.copy(channel, STDOUT)
#   end
#   session.open_session do |ch|
#     ch.request_pty("vt100")
#     ch.shell
#     session.blocking = false

# end


