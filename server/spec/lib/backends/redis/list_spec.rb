require 'spec_helper'

describe Picky::Backends::Redis::List do

  let(:client) { stub :client }
  let(:index) { described_class.new client, :some_namespace }

  describe '[]' do
    it 'returns whatever comes back from the backend' do
      client.stub! :zrange => [:some_lrange_result]

      index[:anything].should == [:some_lrange_result]
    end
    it 'calls the right method on the backend' do
      client.should_receive(:zrange).once.with "some_namespace:some_sym", :"0", :"-1"

      index[:some_sym]
    end
  end

  describe 'to_s' do
    it 'returns the cache path with the default file extension' do
      index.to_s.should == 'Picky::Backends::Redis::List(some_namespace:*)'
    end
  end

end