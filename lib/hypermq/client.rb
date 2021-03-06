require 'faraday'
require 'yajl'
require 'id'

module HyperMQ
  class Client

    def initialize(name, host, port=80)
      @name = name
      @host = host
      @port = port
    end

    def domain
      "http://#{host}:#{port}"
    end

    def push(queue, message)
      url = [domain, 'q', queue].join('/')
      Faraday.post(url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = Yajl::Encoder.encode(producer: name, body: message)
      end.env[:status] == 201
    end

    def fetch(queue, message_id=nil)
      url = [domain, 'q', queue, message_id].compact.join('/')
      response = Faraday.get(url).env[:body]
      Yajl::Parser.parse(response)
    end

    def acknowledge(queue, message_id)
      url = [domain, 'ack', queue, name].join('/')
      status = Faraday.post(url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = %-{"id":"#{message_id}"}-
      end.env[:status]
      status.to_i == 201
    end

    def last_seen(queue)
      url = [domain, 'ack', queue, name].join('/')
      response = Faraday.get(url).env[:body]
      Yajl::Parser.parse(response).fetch('message')
    end

    private
    attr_reader :name, :host, :port

  end
end
