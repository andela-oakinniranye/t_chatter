module TChatter
  class Chat
    attr_reader :connection, :messages, :response, :last_message_id, :user, :user_id, :config, :url, :all_users
    # attr_accessor :url

    def initialize(username, config_class)
      @user = username
      @messages = []
      @last_message_id = 0
      @all_users = []
      @config = config_class.configuration
      @user_id = config[:user_id] || UNIQUE_ID
      set_url
      connect
      subscribe_user
    end

    def subscribe_user
      connection.post('/new_user', {user_id: user_id , user: user})
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
        @url = URI.parse(DEFAULT_URL)
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
      @response = JSON.parse(response.body)
      @last_message_id = @response["last_message_id"]
      @messages << message
      @last_message = message
    end

    def receive_message
      sleep 2
      response = connection.get('/receive', { last_message_id: @last_message_id })
      @response = JSON.parse(response.body)
      last_id = @response["last_message_id"]
      unless last_id == last_message_id
        message = @response["message"]
        puts message
        @last_message_id = last_id
        update_messages(message) unless message.blank?
      end
      get_subscribed_users if all_users.size < @response["total_users"].to_i
    end

    def update_messages(message)
      message = message.split("\n")
      @last_message = message.last
      @messages += message
    end

    def get_subscribed_users
      response = connection.get('/all_users')
      response = JSON.parse(response.body)
      @all_users = response["users"]
    end

    def each_user
      @all_users.map{ |y| y['name'] }.join(', ')
    end

    def show_all_users
      puts @all_users.map{ |y| "#{y['name']} joined at #{y['joined']}"}.join("\n")
    end

    def quit
      connection.get('/quit', {user_id: user_id})
    end
  end
end
