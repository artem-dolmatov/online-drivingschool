user ||= @user
token ||= @token

json.id             user.id
json.name           user.full_name
json.email          user.email
json.role           id: user.role.id,
                    name: user.role.name
json.token          token.auth_token unless token.nil?
