### Get Started

rails g model message send_user_id:string target_user_id:string content:string received:string readed:string

class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  field :send_user_id, type: String
  field :target_user_id, type: String
  field :content, type: String
  # "1" mean is receive
  field :received, type: String, default: "0"
  # "1" mean is read
  field :readed, type: String, default: "0"
  #field :last_message_id, type: String

  ## sequence number
  field :message_sequence, :type => Integer
  sequence :message_sequence
end

### build relationship between user and message

```shell
class Message
# https://github.com/mongoid/mongoid/issues/1973
  belongs_to :send_user, class_name: "User", foreign_key: :send_user_id, inverse_of: "send_messages"
  belongs_to :target_user, class_name: "User", inverse_of: :receive_messages
end

# encoding: UTF-8
module Userable
  extend ActiveSupport::Concern

  included do

    has_many :send_messages, :class_name => "Message", :inverse_of => "send_user"
    has_many :receive_messages, :class_name => "Message", :inverse_of => "target_user"
  end
end
```

### define messages controller

which include action: `send`, `read`, `delete_session`, `deletemessage`


### oauth with message

```shell
app = Doorkeeper::Application.limit(3)[1]
client = OAuth2::Client.new(app.uid, app.secret, :site => "http://localhost:3000")
action_wrap = Http::ActionWrap.new({url: "http://localhost:3000"})
oauth_params = {
                 grant_type: "client_credentials",
                 client_id: client.id,
                 client_secret: client.secret
               }

#oauth_params = {
#                 grant_type: "password",
#                 username: "test@qq.com",
#                 password: "11111111",
#                 client_id: client.id,
#                 client_secret: client.secret
#               }

nomal_param = {path: "/oauth/token",param: {} }
#request_params = oauth_params.merge(path: "/oauth/token")
#action_wrap.get(request_params)
action_wrap.post(nomal_param,oauth_params)

#uri = URI('http://localhost:3000/oauth/token')
#res = Net::HTTP.post_form(uri, oauth_params)
#puts res.body

access_hash = JSON.parse action_wrap.post(nomal_param,oauth_params)

access = OAuth2::AccessToken.from_hash(client, access_hash)
send_user = User.desc(:id).limit(3).shuffle.first
target_user = User.limit(2).shuffle.first
message_hash =  {
                  send_user_id: send_user.id,
                  target_user_id: target_user.id,
                  content: "2134asdfasdf"
                }
send_message = access.get('/api/v1/messages/send_message', body: message_hash).parsed
read_hash = {id: "2341234", message_sequence: 1241234 }
send_message = access.get('/api/v1/messages/read', body: read_hash ).parsed
```

### Using Resource Owner Password Credentials flow

base on [doorkeeper's wiki](https://github.com/applicake/doorkeeper/wiki/Using-Resource-Owner-Password-Credentials-flow)

```shell
app = Doorkeeper::Application.limit(1).first
uri = URI app.redirect_uri
uri.path = ""
client = OAuth2::Client.new(app.uid, app.secret, :site => uri)
access_token = client.password.get_token('user@example.com', 'doorkeeper')
puts access_token.token
```

### socket

# TODO
