module TCharter
  class Chat
    attr_reader :connection, :messages, :response, :last_message_id, :user, :config

    def initialize(username, config_class)
      @user = username
      @messages = []
      @last_message_id = 0
      @config = config_class.configuration
      set_url
      connect
    end

    def set_url
      @url = @config[:host]
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
