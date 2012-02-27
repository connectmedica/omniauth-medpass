require 'omniauth/strategies/open_id'
require 'multi_json'

module OmniAuth
  module Strategies
    class Medpass < OmniAuth::Strategies::OpenID
      URI_SCHEME_REGEXP = /[#{URI::REGEXP::PATTERN::ALPHA}][-+.#{URI::REGEXP::PATTERN::ALPHA}\d]*/

      args :api_key

      option :api_key, nil
      option :name, :medpass
      option :site, 'http://medpass.pl'
      option :openid_url_scheme, 'http://%{login}.medpass.pl'
      option :identifier_param, 'login'

      uid { openid_response.display_identifier }

      info do
        {
            'email'       => raw_info['email'],
            'nickname'    => raw_info['display_name'], # Also available: openid_response.display_identifier
            'first_name'  => raw_info['firstname'],
            'last_name'   => raw_info['lastname'],
            'location'    => raw_info['city'], # Also available: address, postcode, province
            'description' => raw_info['about'],
            'image'       => user_avatar_uri.to_s,
            'phone'       => raw_info['phone'], # Also available: mobile_phone
            'urls'        => {
                options.name.to_s.capitalize => openid_url
            }
        }
      end

      extra do
        { 'raw_info' => raw_info }
      end

      def get_identifier
        f = OmniAuth::Form.new(:title => 'Medpass Authentication')
        f.label_field('Medpass Identifier', options.identifier_param)
        f.input_field('url', options.identifier_param)
        f.to_response
      end

      def identifier
        i = request.params[options.identifier_param.to_s]
        i = i !~ /\S/ ? nil : openid_url_from_login(i)
        i
      end

      private

      def raw_info
        @raw_info ||= options.api_key ? MultiJson.decode(Net::HTTP.get(user_profile_uri)) : {}
      end

      def user_profile_uri
        @user_profile_uri ||= URI.parse("#{options.site}/resource_api/users/#{encode_login(login)}?api_key=#{options.api_key}&full_profile=1")
      end

      def user_avatar_uri
        @user_avatar_uri ||= URI.parse("#{options.site}/profile/get_avatar?login=#{login}&size=small") # "Small" = 50x50
      end

      def login
        @login ||= login_from_openid_url(openid_response.display_identifier)
      end

      def openid_url
        @openid_url ||= openid_url_from_login(openid_response.display_identifier)
      end

      def login_from_openid_url(openid_url)
        return nil if openid_url !~ /\S/

        # Remove parts guessed from options[:openid_url_scheme]
        parts = options.openid_url_scheme.rpartition('%{login}')
        openid_url.gsub!(/^#{parts.first}/, '')
        openid_url.gsub!(/#{parts.last}$/, '')

        # Remove host and port guessed from options[:site]
        uri = URI.parse(options.site)
        openid_url.gsub!(/\.#{uri.host}(?::\d*)?\/*$/, '')

        # Remove some common parts - scheme and trailing slashes
        openid_url.gsub!(/^#{URI_SCHEME_REGEXP}:\/\//, '')
        openid_url.gsub!(/\/+$/, '')

        openid_url
      end

      def openid_url_from_login(login)
        return nil if login !~ /\S/

        options.openid_url_scheme % {:login => login_from_openid_url(login)}
      end

      def encode_login(login)
        login.to_s.gsub('.', '-dot-')
      end

    end
  end
end

