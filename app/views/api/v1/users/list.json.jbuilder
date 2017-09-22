json.users @users,
           partial: 'show.json',
           as: :user
json.count @users.count