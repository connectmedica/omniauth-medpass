# OmniAuth Medpass &nbsp;[![Build Status](https://secure.travis-ci.org/connectmedica/omniauth-medpass.png)][travis]&nbsp;[![Dependency Status](https://gemnasium.com/connectmedica/omniauth-medpass.png?travis)][gemnasium]

Medpass OAuth2 Strategy for [OmniAuth 1.0](https://github.com/intridea/omniauth) authentication system.

[travis]: http://travis-ci.org/connectmedica/omniauth-medpass
[gemnasium]: https://gemnasium.com/connectmedica/omniauth-medpass

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-medpass'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-medpass

## Quick start

    $ MEDPASS_API_KEY="you_medpass_api_key" ruby examples/sinatra.rb

## Configuration

```ruby
require 'omniauth-medpass'
require 'openid/store/filesystem'

use Rack::Session::Cookie
use OmniAuth::Strategies::Medpass, ENV['MEDPASS_API_KEY'], :store => OpenID::Store::Filesystem.new('/tmp')
```

Block style:

```ruby
require 'omniauth-medpass'
require 'openid/store/filesystem'

use OmniAuth::Builder do
  provider :medpass, 'YOUR_MEDPASS_API_KEY', :store => OpenID::Store::Filesystem.new('/tmp')
end
```

*Medpass API Key* is optional - you do not need it to successfully authenticate user - but if you provide it, you will have access to full Auth Hash data.

For more information about configuring OpenID strategy, see [original documentation](https://github.com/intridea/omniauth-openid).

Note that default OpenID stores (`memory` and `filesystem`) will not work on clustered servers (unless they all share same store path).

## Usage

```html
<a href="/auth/medpass">Sign in with Medpass</a>
```

...and then retrieve authenticated user data in callback (here using Sinatra):

```ruby
post '/auth/unipass/callback' do
  User.create(:id => request.env['omniauth.auth'].id)
end
```

## Auth Hash

Exemplary Auth Hash obtained after successful authentication:

```ruby
{
  'provider' => 'medpass',
  'id' => 'eilda.bleet',
  'info' => {
    'name'        => 'Eilda Bleet',
    'email'       => 'eilda@bleet.com',
    'nickname'    => 'anonimowy użytkownik', # user can hide his display_name
    'first_name'  => 'Eilda',
    'last_name'   => 'Bleet',
    'location'    => 'Poznań',
    'description' => 'Absolwentka wyższej szkoły organizacji turystyki i hotelarstwa.',
    'image'       => 'http://medpass.pl/profile/get_avatar?login=eilda.bleet&size=small',
    'phone'       => nil,
    'urls'        => {
      'medpass' => 'http://eilda.bleet.medpass.pl'
    }
  },
  'extra' => {
    'raw_info' => {
      'medpass_id'       => 123,
      'login'            => 'eilda.bleet',
      'firstname'        => 'Eilda',
      'lastname'         => 'Bleet',
      'title'            => 'Dr',
      'display_name'     => 'anonimowy użytkownik',
      'email'            => 'eilda@bleet.com'
      'group'            => 2,
      'group_key'        => 'DOC',
      'city'             => 'Poznań',
      'address'          => 'Lipna 27',
      'postcode'         => '01-234',
      'mobile_phone'     => '521324354',
      'phone'            => '229876543',
      'skype'            => 'eilda1717',
      'gadu'             => nil,
      'pwz'              => '696969',
      'speciality'       => nil,
      'about'            => 'I love pancakes!',
      'gender'           => 1,
      'company_name'     => 'Activeweb',
      'company_address'  => 'Wiatru w polu 3',
      'company_city'     => 'Gdynia',
      'company_postcode' => nil,
      'company_province' => 'śląskodąbrowskie',
      'company_phone'    => nil,
      'is_superviewer'   => false,
      'province' => {
        'province' => {
          'name' => 'mazowieckie',
          'code' => '14',
          'id'   => 7
        }
      }
    }
  }
}
```

Note that this information is available only if you provide valid Medpass API Key.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
