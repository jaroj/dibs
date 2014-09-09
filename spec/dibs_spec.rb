require 'spec_helper'

describe Dibs do
  context 'Authorization' do
    before(:each) do
      @dibs = ::Dibs::APIWrapper.new(
        API_CONFIG['merchant'], API_CONFIG['key1'], API_CONFIG['key2'])
      @good_looking_data = {
        amount: '2000',
        currency: '208', # DDK
        cardno: '5019100000000000',
        expmon: '12',
        expyear: '05',
        cvc: '123',
        orderId: '12345',
        fullreply: true,
        test: true }
    end

    it 'should authorize transaction for properly provided data' do
      res = @dibs.authorize(@good_looking_data)
      expect(res.accepted?).to eq true
    end

    it 'should throw an exception' do
      @good_looking_data.delete(:cardno)
      expect { @dibs.authorize(@good_looking_data) }.to raise_error
    end
  end

  context 'Capture' do
    before(:each) do
      @dibs = ::Dibs::APIWrapper.new(
        API_CONFIG['merchant'], API_CONFIG['key1'], API_CONFIG['key2'])
      @good_looking_data = {
        amount: 2000,
        orderid: "abc_test_#{Time.now.to_s.gsub(/\s/, '_')}",
        transact: '123456'
        # test: true doesn't have test param
      }
    end

    it 'returns DECLINED' do
      res = @dibs.capture(@good_looking_data)
      expect(res.accepted?).to eq false
      expect(res.result_parsed['message']).to include 'Unknown transaction id'
    end
  end

  context 'Cancel' do
    before(:each) do
      @dibs = ::Dibs::APIWrapper.new(
        API_CONFIG['merchant'], API_CONFIG['key1'], API_CONFIG['key2'])
      @good_looking_data = {
        orderid: "abc_test_#{Time.now.to_s.gsub(/\s/, '_')}",
        transact: '123456',
        username: API_CONFIG['username'],
        password: API_CONFIG['password']
        # test: true doesn't have test param
      }
    end

    # if login to account failed 3 times account will be blocked for 30 min
    # it 'returns DECLINED' do
    #   res = @dibs.cancel(@good_looking_data)
    #   raise res.inspect
    # end
  end

  context 'Ticket Auth' do
    before(:each) do
      @dibs = ::Dibs::APIWrapper.new(
        API_CONFIG['merchant'], API_CONFIG['key1'], API_CONFIG['key2'])
      @good_looking_data = {
        orderid: "abc_test_#{Time.now.to_s.gsub(/\s/, '_')}",
        ticket: '270000543',
        amount: '1000',
        currency: '208',
        orderId: 'A Ticket Draw',
        test: true
      }
    end

    # it 'retuns ACCEPTED' do
    #   res = @dibs.ticket_auth(@good_looking_data)
    #   expect(res.accepted?).to eq true
    # end

    it 'returns DECLINED' do
      res = @dibs.ticket_auth(@good_looking_data)
      expect(res.accepted?).to eq false
    end
  end

  context 'Refund' do
    before(:each) do
      @dibs = ::Dibs::APIWrapper.new(
        API_CONFIG['merchant'], API_CONFIG['key1'], API_CONFIG['key2'])
      @good_looking_data = {
        orderid: "abc_test_#{Time.now.to_s.gsub(/\s/, '_')}",
        transact: '123456',
        username: API_CONFIG['username'],
        password: API_CONFIG['password'],
        currency: '208',
        amount: '1000'
        # test: true doesn't have test param
      }
    end

    # it 'returns DECLINED' do
    #   res = @dibs.refund(@good_looking_data)
    #   # raise res.inspect
    #   expect(res.accepted?).to eq false
    # end
  end
end
