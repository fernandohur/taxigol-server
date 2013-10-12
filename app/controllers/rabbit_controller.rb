

class RabbitController < ApplicationController

  def initialize
    HomeController.message_queue
  end

  # Opens a producer connection to the RabbitMQ service, if one isn't
  # already open.  This is a class method because a new instance of
  # the controller class will be created upon each request.  But AMQP
  # connections can be long-lived, so we would like to re-use the
  # connection across many requests.
  def self.producer
    unless @producer
      conn = Bunny.new(ENV['RABBITMQ_BIGWIG_TX_URL'])
      conn.start
      ch = conn.create_channel
      q = ch.queue("prueba")
      ch.default_exchange.publish("Hello World!", :routing_key => q.name)
      puts " [x] Sent 'Hello World!'"

    end
    @producer
  end

end
