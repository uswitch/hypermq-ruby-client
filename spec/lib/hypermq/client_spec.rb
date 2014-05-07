require 'spec_helper'

describe HyperMQ::Client do

  let (:client) { HyperMQ::Client.new('test-client', 'hypermq.yourdomain.com') }

  before do
    stub_request(:get, "http://hypermq.yourdomain.com/q/myqueue").to_return(File.read('spec/support/myqueue-from-beginning.json'))
    stub_request(:get, "http://hypermq.yourdomain.com/q/myqueue/c35e12a0-d502-11e3-a3db-7831c1b71f12").to_return(File.read('spec/support/myqueue-next.json'))
    stub_request(:post, "http://hypermq.yourdomain.com/ack/myqueue/test-client").to_return(File.read('spec/support/myqueue-ack.json'))
    stub_request(:get, "http://hypermq.yourdomain.com/ack/myqueue/test-client").to_return(File.read('spec/support/myqueue-last-seen.json'))
    stub_request(:post, "http://hypermq.yourdomain.com/q/myqueue").
      with(:body => "{\"producer\":\"test-client\",\"body\":{\"some\":\"data\"}}").
      to_return(File.read('spec/support/myqueue-create.json'))
  end


  describe "#fetch" do
    it "requests the first page of messages when called without a second argument" do
      expect(client.fetch('myqueue')).to eq ({
        "queue"=>"myqueue",
        "_embedded"=>{"message"=>[{
          "created"=>1399369359563,
          "body"=>{"some"=>"data"},
          "producer"=>"myproducer",
          "queue"=>"myqueue",
          "id"=>"c35e12a0-d502-11e3-a3db-7831c1b71f12"
        }]},
        "_links"=>{"self"=>{"href"=>"http://hypermq.yourdomain.com/q/myqueue"}}})
    end

    it "requests the page of messages after a given id when called with that id as its second argument" do
      expect(client.fetch('myqueue', "c35e12a0-d502-11e3-a3db-7831c1b71f12")).to eq ({
        "queue"=>"myqueue",
        "_embedded"=>{"message"=>[{"created"=>1399473341221, "body"=>{"msg"=>1},
                                   "producer"=>"myproducer", "queue"=>"myqueue", "id"=>"dd441550-d5f4-11e3-b17b-7831c1b71f12"}]},
                                   "_links"=>{"prev"=>{"href"=>"http://hypermq.yourdomain.com/q/myqueue"},
                                              "self"=>{"href"=>"http://hypermq.yourdomain.com/q/myqueue/c35e12a0-d502-11e3-a3db-7831c1b71f12"
      }}})
    end
  end

  describe "#acknowledge" do
    it 'acknowledges receipt of a message' do
      expect(client.acknowledge('myqueue', 'c35e12a0-d502-11e3-a3db-7831c1b71f12')).to be_true
    end
  end

  describe "#last_seen" do
    it 'returns the id of the last acknowledged message' do
      expect(client.last_seen('myqueue')).to eq 'a35e12a0-d502-11e3-a3db-831c1b71f112'
    end
  end

  describe "#push" do
    it 'pushes a message onto the queue' do
      expect(client.push('myqueue', some: 'data')).to be_true
    end
  end
end
