# Start

```shell
rails new oauth_provider_demo -j=coffee --skip-bundle --skip-test-unit --skip-active-record
cd oauth_provider_demo/

rvm --create --ruby-version use 1.9.3@oauth_provider_demo
rvm --create --versions-conf use 1.9.3@oauth_provider_demo

gem install bundler
bundle install

rails g mongoid:config

rails generate devise:install
rails g mongoid:devise user
rails generate devise:views
```

### generate doorkeeper

```shell
rails generate doorkeeper:install
```

```shell
There is a setup that you need to do before you can use doorkeeper.

Step 1.
Go to config/initializers/doorkeeper.rb and configure
resource_owner_authenticator block.

Step 2.
Choose the ORM:

If you want to use ActiveRecord run:

  rails generate doorkeeper:migration

And run

  rake db:migrate

If you want to use Mongoid, configure the orm in initializers/doorkeeper.rb:

# Mongoid
Doorkeeper.configure do
  orm :mongoid
end

If you want to use MongoMapper, configure the orm in
initializers/doorkeeper.rb:

# MongoMapper
Doorkeeper.configure do
  orm :mongo_mapper
end

And run

  rails generate doorkeeper:mongo_mapper:indexes
  rake db:index

Step 3.
That's it, that's all. Enjoy!

===============================================================================
```

```shell
rails  g doorkeeper:views

rake db:setup
rake db:mongoid:create_indexes
```


### how it work

#### resources

*  https://github.com/applicake/doorkeeper/wiki/Testing-your-provider-with-OAuth2-gem
*  https://github.com/applicake/doorkeeper/wiki/Example-Applications

### manage application

navigeter to http://localhost:3000/oauth/applications

## Tips

If you want to use this for registering a mobile client for example, you might want
to skip the "authorize application" process. This way you won't have to ask your client
to authorize on the server with a web browser. You will just get your token from
the api server.

You can simulate a client using `curl`:

    curl -i http://localhost:3000/oauth/token \
    -F grant_type="client_credentials" \
    -F client_id="your_application_id" \
    -F client_secret="your_secret"

You can use user credentials to get the token without validations:

    curl -i http://localhost:3000/oauth/token \
    -F grant_type="password" \
    -F username="a_user_email_address" \
    -F password="a_user_password" \
    -F client_id="your_application_id" \
    -F client_secret="your_secret"

You can use `irb` console to test:

	irb -r oauth2

Then in the console:

    app = Doorkeeper::Application.last
    app = Doorkeeper::Application.limit(3)[1]
    client = OAuth2::Client.new(app.uid, app.secret, :site => "http://localhost:3000")
    app_id = app.uid
    secret = app.secret
    #app_id = "your_app_id"
    #secret = "your_secret"
    client = OAuth2::Client.new(app_id, secret, site: "http://localhost:3000")
    # access = OAuth2::AccessToken.from_hash(client, {"access_token" => "3ff71dd5c7afaba4371f40c8d4afa915ee9cfc48487dad4c935b0a636db0aa32","token_type" => "bearer","expires_in" => 7200})
    access = OAuth2::AccessToken.from_hash(client, {"access_token" => "the_token_returned_from_curl_command","token_type" => "bearer","expires_in" => 7200})

    # access.get('/api/v1/me').parsed # not work on mongoid
    access.get('/api/v1/fast').parsed
    access.get('/api/v1/users').parsed

    access.get('/api/v1/profiles')
    access.get('/api/v1/profiles', {id: "519337b3d98ca490d1000019"}).parsed

    access.post('/api/v1/users', body: {user: {email: 'testuser@bar.com', password: '1212121'}}).parsed
    access.post('/api/v1/profiles', body: {profile: {name: 'name1', username: "username1", email: 'exampleemail@qq.com'}}).parsed

    #access.delete('/api/conversations/5022caba1de760379b000003/messages/5022caba1de760379b000004').parsed


Note: When making the POST request on `/api/users`, you'll probable want to do it without a token you've got from curl passing some user's credentials. In another word, my example is made such that you can create a new user from an API call passing a valid token, but a token acquired without some user's credentials. Like the curl command we saw previously:

	curl -i http://localhost:3000/oauth/token \
    -F grant_type="client_credentials" \
    -F client_id="your_application_id" \
    -F client_secret="your_secret"

Then you could get a brand new token (and use this one for further requests if you want change the "current_user" context to your new user) acquired this time with your new user's credentials.

### Note on CORS (Cross Origin Resource Sharing)

You might be cronfronted to some issues while requesting for an other domain (from a mobile application for example).

For this demo application, I have used [rack-cors](https://github.com/cyu/rack-cors) middleware in order to set HTTP headers to allow [CORS](http://www.nczonline.net/blog/2010/05/25/cross-domain-ajax-with-cross-origin-resource-sharing/).

That's it for now !
