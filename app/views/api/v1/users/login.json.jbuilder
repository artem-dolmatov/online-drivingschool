user  ||= @user

json.user user,
          partial: 'show.json',
          as: :user