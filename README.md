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

*Medpass API Key* is not mandatory - you do not need it to successfully authenticate user - but if you provide it, you will have access to full Auth Hash data.

For more information on configuring OpenID strategy, see [original documentation](https://github.com/intridea/omniauth-openid).

Note that default OpenID stores (`memory` and `filesystem`) will not work on clustered servers (unless they all share same store path).

## Usage

```html
<a href="/auth/medpass">Sign in with Medpass</a>
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
      'city'             => 'Poznań',
      'address'          => 'Lipna 27',
      'group'            => 2,
      'skype'            => 'eilda1717',
      'group_key'        => 'DOC',
      'company_city'     => 'Gdynia',
      'title'            => 'Dr',
      'postcode'         => '01-234',
      'company_name'     => 'Activeweb',
      'speciality'       => nil,
      'company_phone'    => nil,
      'is_superviewer'   => false,
      'gadu'             => nil,
      'lastname'         => 'Bleet',
      'gender'           => 1,
      'about'            => 'I love pancakes!',
      'company_postcode' => nil,
      'phone'            => '987654321',
      'firstname'        => 'Eilda',
      'medpass_id'       => 123,
      'company_province' => 'śląskodąbrowskie',
      'display_name'     => 'anonimowy użytkownik',
      'pwz'              => '696969',
      'login'            => 'eilda.bleet',
      'company_address'  => nil,
      'mobile_phone'     => '',
      'email'            => 'eilda@bleet.com'
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
