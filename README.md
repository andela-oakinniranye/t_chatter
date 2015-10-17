# TChatter

## Installation
Install with:
```
  gem install t_chatter
```
May not be useful in your application though, but in case you want to experiment with it

```
  gem t_chatter
```

## Setup
I have written a small setup script which only requires you run:
```
  setup_t_chatter
```
It takes you through an interactive console to setup the chatter.

All the answers are optional.
In case you don't want to use the default server the application uses, you can also enter your own server
Make sure you have a `\receive` route which sends a response in JSON format. The response must contain a
`message` and `last_message_id` keys.
And the `\send` route which accepts a post request and returns the `last_message_id` key.

## Usage
To check it out, simply call type:
```
  t_chatter
```
on your terminal and watch the message stream in.

If you specified to receive message, you will only see the messages, if to send message you will only be able to send
However if you specified for both, you can both send an receive messages.

Don't worry if you didn't do it at first though. you can always set it up again.

```
  PS: To keep the application as slim and compact as possible, there is no database involved in this application nor the server, everything is stored in an array which puts us at the mercy of the hosting provider and updates. Therefore don't expect much in terms of data persistence.
```

## History

Thanks for wanting to try out TChatter.
TChatter is just an experiment and a hack on concurrency in Ruby applications.
So, I was thinking of something crazy I could do while learning something new and
I thought of a chat messenger. However, there are many chat messengers out there
And another could easily be spawned if I was using a web framework, therefore not
much of a learning.
I then thought of a chatting application on the terminal hence: TChatter(Terminal Chatter)
The problem I realized I would have encountered which wasn't much of a problem in
a web application was concurrency:
`How do I implement an application that would listen for input from the user as well
as update almost in realtime the content on another terminal.`

### Solutions
`The first solution may not always be the best solution`

The first solution I thought of was a sort of loop, however this was a blocking solution,
I could have put it in a Timeout block, however, this still didn't seem to be the best

In came EventMachine, which was awesome.
Due to a very shallow understanding of EventMachine I used some sort of periodic timer which
which also didnt appear to be the best solution, as I had to send messages on one terminal
and receive on another.

Thread to the rescue
Then I learnt of the Ruby Thread which was no finally used.
The Thread seem to be the most effecient as it could do many things at the same time.

One major pitfall with Thread is that it may not be stopped even after exiting your
loop in the application as it 'kinda' freezes my console (I had to depress a key twice
for the console to respond).

The way I found around that was to use the Ruby trap method as in
```ruby
  trap("INT") {
    puts "Exiting the chat"
    threads.each{|t|
      t.exit
    }
  }
```
Thanks to [SO(stackoverflow)](http://stackoverflow.com/questions/27642943/kill-all-threads-on-terminate?answertab=votes#tab-top).

This is not close to the best application I have and will build, however I seem to be most excited
about this for now.

Let's see where the future takes me.
[To know how I feel about this you have to listen to this](www.youtube.com/watch?v=ZR0v0i63PQ4)


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andela-oakinniranye/t_chatter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
