# encoding: UTF-8
require 'dibs/version'
require 'net/http'
require 'net/https'
require 'digest/md5'
require 'results.rb'
require 'errors.rb'
require 'active_support/core_ext'

module Dibs
  class APIWrapper
    def initialize(merchant, key1, key2)
      @merchant, @key1, @key2 = merchant, key1, key2
      @flex_win_server = 'https://payment.architrade.com'
    end

    def authorize(opts = {})
      opts = {
        merchant: @merchant,
        amount: 0,
        currency: '',
        cardno: '',
        expmon: '',
        expyear: '',
        cvc: '',
        orderId: '',
        test: false
      }.merge!(opts)
      opts.symbolize_keys!
      check_for_missing_parameter(
        opts, %w(merchant amount currency cardno expmon expyear cvc orderId))
      md5 = "#{@key1}merchant=#{@merchant}&orderid=#{opts[:orderId]}&currency=#{opts[:currency]}&amount=#{opts[:amount]}"
      opts[:md5key] = calculate_md5(md5)
      endpoint = "#{@flex_win_server}/cgi-ssl/auth.cgi"
      # raise opts.inspect
      res = do_http_post(opts, endpoint)
      # raise res.body.inspect
      ::Dibs::Results::PaymentAuth.new(res.body)
    end

    # def call_authorize_with_test_data
    #   authorize
    # end

    # no test option
    def capture(opts = {})
      opts = {
        merchant: @merchant,
        amount: 0,
        transact: 0,
        orderid: ''
      }.merge!(opts)
      check_for_missing_parameter(
        opts, %w(merchant amount transact orderid))
      md5 = "#{@key1}merchant=#{@merchant}&orderid=#{opts[:orderId]}&transact=#{opts[:transact]}&amount=#{opts[:amount]}"
      opts[:md5key] = calculate_md5(md5)
      endpoint = "#{@flex_win_server}/cgi-bin/capture.cgi"
      res = do_http_post(opts, endpoint)
      # raise res.body.inspect
      ::Dibs::Results::PaymentHand.new(res.body)
    end

    # no test option
    def cancel(opts = {})
      opts = {
        merchant: @merchant,
        orderid: '',
        transact: 0
      }.merge!(opts)
      check_for_missing_parameter(
        opts, %w(merchant orderid transact username password))
      md5 = "#{@key1}merchant=#{@merchant}&orderid=#{opts[:orderid]}&transact=#{opts[:transact]}"
      opts[:md5key] = calculate_md5(md5)
      endpoint = "https://#{opts[:username]}:#{opts[:password]}@payment.architrade.com/cgi-adm/cancel.cgi"
      res = do_http_post(opts, endpoint)
      raise res.body.inspect
      ::Dibs::Results::PaymentHand.new(res.body)
    end

    def ticket_auth(opts = {})
      opts = {
        merchant: @merchant,
        amount: '0',
        currency: '',
        orderId: '',
        ticket: 0,
        test: false
      }.merge!(opts)
      check_for_missing_parameter(
        opts, %w(merchant amount currency orderId ticket))
      md5 = "#{@key1}merchant=#{@merchant}&orderid=#{opts[:orderid]}&ticket=#{opts[:ticket]}&currency=#{opts[:currency]}&amount=#{opts[:amount]}"
      opts[:md5key] = calculate_md5(md5)
      endpoint = "#{@flex_win_server}/cgi-ssl/ticket_auth.cgi"
      res = do_http_post(opts, endpoint)
      ::Dibs::Results::PaymentAuth.new(res.body)
    end

    # no test option
    def del_ticket(opts = {})
      opts = {
        merchant: @merchant,
        ticket: '0'
      }.merge!(opts)
      check_for_missing_parameter(
        opts, %w(merchant ticket))
      endpoint = "https://#{opts[:username]}:#{opts[:password]}@payment.architrade.com/cgi-adm/delticket.cgi"
      res = do_http_post(opts, endpoint)
      ::Dibs::Results::PaymentHand.new(res.body)
    end

    # no test option
    def refund(opts = {})
      opts = {
        merchant: @merchant,
        amount: '0',
        currency: '',
        orderid: '',
        transact: 0
      }.merge!(opts)
      check_for_missing_parameter(
        opts, %w(merchant amount currency orderid transact username password))
      md5 = "#{@key1}merchant=#{@merchant}&orderid=#{opts[:orderid]}&ticket=#{opts[:ticket]}&currency=#{opts[:currency]}&amount=#{opts[:amount]}"
      opts[:md5key] = calculate_md5(md5)
      endpoint = "https://#{opts[:username]}:#{opts[:password]}@payment.architrade.com/cgi-adm/refund.cgi"
      res = do_http_post(opts, endpoint)
      ::Dibs::Results::PaymentHand.new(res.body)
    end

    private

    def do_http_post(opts, endpoint)
      opts[:test] = 'yes' if opts[:test]
      opts[:textreply] = 'yes'
      opts[:fullreply] = 'yes'
      opts[:postype] = 'ssl'
      uri = URI("#{endpoint}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.post(uri.path, opts.to_query)
    end

    def calculate_md5(md5)
      md5 = Digest::MD5.hexdigest(md5)
      Digest::MD5.hexdigest("#{@key2}#{md5}")
    end

    def check_for_missing_parameter(opts, keys_array)
      keys_array.each do |k|
        ks = k.to_sym
        fail ::Dibs::Errors::ParameterMissingError if !opts[ks] || opts[ks].blank?
      end
    end
  end
end
