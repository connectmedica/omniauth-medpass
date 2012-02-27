require 'rubygems'
require 'bundler'

Bundler.setup :default, :development, :example

require 'sinatra'
require 'omniauth-medpass'

use Rack::Session::Cookie
use OmniAuth::Strategies::Medpass, ENV['MEDPASS_API_KEY']

get '/' do
  <<-HTML
  <ul>
    <li><a href='/auth/medpass'>Sign in with Medpass</a></li>
  </ul>
  HTML
end

[:get, :post].each do |method|
  send method, '/auth/:provider/callback' do
    '<dl>' + request.env['omniauth.auth'].info.map{ |k, v| "<dt>#{k}</dt><dd>#{v.inspect}</dd>" }.join + '</dl>'
  end
end
