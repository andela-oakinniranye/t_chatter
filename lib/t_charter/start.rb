module TCharter
  class Start

    def self.chat
      config = ConfigSetup.instance
      user = config.configuration[:user]

      # host = config[:host]
      unless user
        print "Would you mind telling me your name? > "
        user = gets.chomp
      end

      chat = Chat.new(user, config)

      want_to_receive = config.configuration[:receive] || true
      want_to_send = config.configuration[:send] || true

      threads = []


      if want_to_receive
        #response object
        threads << Thread.new do
          loop{
            chat.receive_message
          }
        end
      end

      if want_to_send
        #request object
        threads << Thread.new do
          loop{
            message = gets.chomp
            chat.send_message(message) if message
          }
        end
      end

      trap("INT") {
        puts "Exiting the chat"
        threads.each{|t|
          t.exit
        }
      }

      threads.each{ |thread|
        thread.join
      }
  end
  end
end
