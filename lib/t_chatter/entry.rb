module TChatter
  class Entry
    attr_reader :user, :config, :chat, :threads

    def initialize
      @config = ConfigSetup.instance
      setup_user
      @chat = Chat.new(@user, @config)
      @threads = []
    end

    def start_chat
      setup_threads
      control_exit_strategy
      start_threads
    end

    def want_to_send?
      @config.configuration.blank? ? true : @config.configuration[:send]
    end

    def want_to_receive?
      @config.configuration.blank? ? true : @config.configuration[:receive]
    end

    def setup_user
      @user = config.configuration[:user]
      unless @user
        print 'Would you mind telling me your name? : '
        @user = gets.chomp
      end
    end

    def stream_messages
      Thread.new do
        loop do
          chat.receive_message
        end
      end
    end

    def variables_subs
      { '@my_name' => chat.user.to_s, '@last_message' => chat.messages.last.to_s, '@each_user' => chat.each_user }
    end

    def substitute_variables(message)
      variables_subs.each do |var, val|
        message = message.gsub(var, val)
      end
      message
    end

    def peep
      chat.show_all_users
    end

    def help
      var_help = variables_subs.keys.join(', ')
      command_help = commands.keys.join(', ')
      puts <<-EOS
        Use the following variables in any message to refer to its inferred
        meaning in any message: #{var_help}
        You can use any of these commands to also call the inferred action
        #{command_help}
      EOS
    end

    def quit
      puts "Gracefully shutting down the chat"
      chat.quit
      @threads.each(&:exit)
    end

    def commands
      {
        '#all_users' => :peep,
        '#help' => :help,
        '#quit' => :quit
      }
    end

    def send_messages
      Thread.new do
        loop do
          message = gets.chomp.strip
          unless commands.keys.include? message
            message = substitute_variables(message) if message.match(/@\w+/)
            chat.send_message(message) unless message.blank?
          else
            send(commands[message])
          end
        end
      end
    end

    def control_exit_strategy
      trap('INT') do
        quit
      end
    end

    def setup_threads
      @threads << stream_messages if want_to_receive?
      @threads << send_messages if want_to_send?
    end

    def start_threads
      @threads.each(&:join)
    end
  end
end
