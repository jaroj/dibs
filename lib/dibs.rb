# encoding: UTF-8
require 'dibs/version'
require 'net/http'
require 'net/https'
require 'digest/md5'
require 'results.rb'
require 'errors.rb'
module Dibs
  class Dibs
    def initialize(merchant, key1, key2)
      @merchant, @key1, @key2 = merchant, key1, key2
      @server = 'https://payment.architrade.com'
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
        textreply: true,
        test: false
      }.merge!(opts)
      opts.symbolize_keys!
      check_for_missing_parameter(
        opts, %w(merchant amount currency cardno expmon expyear cvc orderId))
      md5 = "#{@key1}merchant=#{@merchant}&orderid=#{opts[:orderId]}&currency=#{opts[:currency]}&amount=#{opts[:amount]}"
      opts[:md5key]=calculate_md5(md5)
      endpoint = '/cgi-ssl/auth.cgi'
      res = do_http_post(opts, endpoint)
      ::Dibs::Results::Authorize.new(res.body)
    end

    def call_authorize_with_test_data
      authorize
    end

    def capture(opts = {})
      opts = {
        merchant: @merchant,
        amount: 0,
        transact: '',
        orderId: '',
        textreply: true,
        test: false,
        force: false
      }.merge(opts)
      fail ::Dibs::Errors::ParameterMissingError if opts[:amount].blank? ||
        opts[:transact].blank? || opts[:orderId].blank?
      md5 = "#{@key1}merchant=#{@merchant}&orderid=#{opts[:orderId]}&transact=#{opts[:transact]}&amount=#{opts[:amount]}"
      opts[:md5key] = calculate_md5(md5)
      endpoint = '/cgi-bin/capture.cgi'
      res = do_http_post(opts, endpoint)
      ::Dibs::Results::Capture.new(res.body)
    end

    private

    def do_http_post(opts, endpoint)
      opts[:test] = 'yes' if opts[:test]
      opts[:textreply] = 'yes'
      opts[:fullreply] = 'yes'
      opts[:postype] = 'ssl'
      uri = URI("#{@server}#{endpoint}")
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
        fail ::Dibs::Errors::ParameterMissingError if !opts[ks] || opts[ks] == ''
      end
    end
  end
end
