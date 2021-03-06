require 'spec_helper'

require 'rack'
require 'picky-client/spec'

require 'sinatra'

describe Picky::TestClient do
  
  class TestApplication < Sinatra::Application
    
    get '/some/path' do
      '{"allocations":[["boooookies",0.0,1,[["title","hell","hell"]],[313]]],"offset":0,"duration":0.000584,"total":1}'
    end
    
  end
  
  let(:client) { described_class.new(TestApplication, :path => '/some/path') }
  
  context 'search' do
    it 'does extract the hash' do
      client.search('unimportant').should == { :allocations => [['boooookies', 0.0, 1, [['title', 'hell', 'hell']], [313]]], :offset => 0, :duration => 0.000584, :total => 1 }
    end
    it 'does extend the result with convenience methods' do
      client.search('unimportant').total.should == 1
    end
  end
  
end
