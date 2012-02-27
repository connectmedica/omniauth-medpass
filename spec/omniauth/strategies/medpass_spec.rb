require 'spec_helper'

describe OmniAuth::Strategies::Medpass, :type => :strategy do

  def app
    strat = OmniAuth::Strategies::Medpass
    Rack::Builder.new {
      use Rack::Session::Cookie
      use strat
      run lambda{ |env| [404, {'Content-Type' => 'text/plain'}, [nil || env.key?('omniauth.auth').to_s]] }
    }.to_app
  end

  def expired_query_string
    'openid=consumer&janrain_nonce=2011-07-21T20%3A14%3A56ZJ8LP3T&openid.assoc_handle=%7BHMAC-SHA1%7D%7B4e284c39%7D%7B9nvQeg%3D%3D%7D&openid.claimed_id=http%3A%2F%2Flocalhost%3A1123%2Fjohn.doe%3Fopenid.success%3Dtrue&openid.identity=http%3A%2F%2Flocalhost%3A1123%2Fjohn.doe%3Fopenid.success%3Dtrue&openid.mode=id_res&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.op_endpoint=http%3A%2F%2Flocalhost%3A1123%2Fserver%2F%3Fopenid.success%3Dtrue&openid.response_nonce=2011-07-21T20%3A14%3A56Zf9gC8S&openid.return_to=http%3A%2F%2Flocalhost%3A8888%2FDevelopment%2FWordpress%2Fwp_openid%2F%3Fopenid%3Dconsumer%26janrain_nonce%3D2011-07-21T20%253A14%253A56ZJ8LP3T&openid.sig=GufV13SUJt8VgmSZ92jGZCFBEvQ%3D&openid.signed=assoc_handle%2Cclaimed_id%2Cidentity%2Cmode%2Cns%2Cop_endpoint%2Cresponse_nonce%2Creturn_to%2Csigned'
  end

  describe '/auth/medpass without an identifier URL' do
    before do
      get '/auth/medpass'
    end

    it 'responds with OK' do
      last_response.should be_ok
    end

    it 'responds with HTML' do
      last_response.content_type.should == 'text/html'
    end

    it 'renders an identifier URL input' do
      last_response.body.should =~ %r{<input[^>]*login}
    end
  end

  describe 'followed by /auth/open_id/callback' do
    context 'successful' do
      #before do
      #  @identifier_url = 'http://me.example.org'
      #  # TODO: change this mock to actually return some sort of OpenID response
      #  stub_request(:get, @identifier_url)
      #  get '/auth/open_id/callback'
      #end

      it 'sets provider to medpass'
      it 'creates auth_hash based on sreg'
      it 'creates auth_hash based on Medpass Resource API'

      #it 'calls through to the master app' do
      #  last_response.body.should == 'true'
      #end
    end

    context 'unsuccessful' do
      describe 'returning with expired credentials' do
        before do
          # get '/auth/open_id/callback?' + expired_query_string
        end

        it 'it redirects to invalid credentials' do
          pending
          last_response.should be_redirect
          last_response.headers['Location'].should =~ %r{invalid_credentials}
        end
      end
    end
  end

end
