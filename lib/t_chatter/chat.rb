module TChatter
  class Chat
    attr_reader :connection, :messages, :response, :last_message_id, :user, :config
    # attr_accessor :url

    def initialize(username, config_class)
      @user = username
      @messages = []
      @last_message_id = 0
      @config = config_class.configuration
      set_url
      connect
    end

    def set_url
      begin
        @url = URI.parse(@config[:host])
      rescue URI::InvalidURIError
        puts <<-EOS
        You dont seem to have a valid URL in your .chatter.yml file\n
        You may run ``setup_t_chatter`` to set a default url which will be
        used everytime you try to connect. However you are now being connected
        to the global chatter stream
        EOS
        @url = URI.parse(TChatter::DEFAULT_URL)
      end
    end

    def unknown_url
      puts "The URL doesn't appear to be valid a URL"
    end


    def connect
      @connection = Faraday::Connection.new(@url)
    end

    def send_message(message)
      response = connection.post('/send', {message: message, user: user})
      response = JSON.parse(response.body)
      @last_message_id = response["last_message_id"]
      @last_message = message
    end

    def receive_message
      sleep 2
      response = connection.get('/receive', { last_message_id: @last_message_id })
      @response = JSON.parse(response.body)
      last_id = @response["last_message_id"]
      unless last_id == last_message_id
        message = @response["message"]
        @last_message_id = @response["last_message_id"]
        @messages << message if message
        puts message
      end
    end
  end
end
