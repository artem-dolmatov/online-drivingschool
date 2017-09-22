require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

set :application_name, 'drivingschool'
set :domain, '138.68.78.51'
company = 'rostixman'
ruby_version = 'ruby-2.3.3'

set :repository, "git@bitbucket.org:#{company}/#{fetch(:application_name)}.git"
set :user, 'deploy'
set :rvm_use_path, '/usr/local/rvm/scripts/rvm'
set :shared_dirs, fetch(:shared_dirs, []).push('public/uploads')
set :shared_files, fetch(:shared_files, []).push('.env.production','.env.development')

nginx_path = "/etc/nginx/sites-available/#{fetch(:application_name)}"
nginx_file = "#{Dir.pwd}/config/nginx.conf"

task :environment do
	command %{source #{fetch(:rvm_use_path)}}
	command %{rvm use #{ruby_version}@#{fetch(:application_name)} --default --create}
end

desc 'Продакшн сервер'
task :production do
	set :deploy_to, "/srv/apps/#{fetch(:application_name)}/production"
	set :branch, 'master'

	invoke :'nginx:init', 'prod'
end

desc 'Тествоый сервере'
task :staging do

	set :deploy_to, "/srv/apps/#{fetch(:application_name)}/staging"
	set :branch, 'staging'

	invoke :'nginx:init', 'stag'
end

desc 'Установка'
task :setup do
	command %{source #{fetch(:rvm_use_path)}}
	command %{rvm install #{ruby_version}}
	command %{touch "#{fetch(:shared_path)}/.env.production"}
	command %{touch "#{fetch(:shared_path)}/.env.development"}
	command %{mkdir -p "#{fetch(:shared_path)}/public/uploads"}
	command %{chmod g+rx,u+rwx "#{fetch(:shared_path)}/public/uploads"}
end

desc 'Настройка nginx'
namespace :nginx do
	task :init, [:env] do |_, args|
		unless args[:env]
			puts 'need env for nginx:init'
			exit 1
		end

		invoke :'nginx:rm', args[:env]
		invoke :'nginx:create', args[:env]
	end
	task :create, [:env] do |_, args|

		unless args[:env]
			puts 'need env for nginx:create'
			exit 1
		end

		command %{echo "#{File.read("#{nginx_file}.#{args[:env]}")}" > #{nginx_path}.#{args[:env]}}
		command %{ln -s  #{nginx_path}.#{args[:env]} /etc/nginx/sites-enabled/}
	end

	task :rm, [:env] do |_, args|
		unless args[:env]
			puts 'need env for nginx:rm'
			exit 1
		end

		command %{rm -f #{nginx_path}.#{args[:env]}}
		command %{rm  -f /etc/nginx/sites-enabled/#{fetch(:application_name)}.#{args[:env]}}
	end
end

desc 'Деплой приложения'
task :deploy do
	deploy do
		invoke :'environment'
		command 'gem install bundler'
		invoke :'git:clone'
		invoke :'deploy:link_shared_paths'
		invoke :'dotenv:build'
		invoke :'bundle:install'
		invoke :'rails:db_migrate'
		invoke :'rails:assets_precompile'
		invoke :'deploy:cleanup'

		on :launch do
			in_path(fetch(:current_path)) do
				command %{mkdir -p tmp/}
				command %{touch tmp/restart.txt}
			end
		end
	end
end

desc 'Создание файла конфигураций'
namespace :dotenv do
	task :build do
		command %{rm -f .env.production}
		command %{rm -f .env.development}

		command %{ln -s #{"#{fetch(:shared_path)}/.env.production"} .env.production}
		command %{ln -s #{"#{fetch(:shared_path)}/.env.development"} .env.development}
	end
end

desc 'Выполнение seed'
task :rake_db_seed do
	invoke :'environment'
	in_path(fetch(:current_path)) do
		command %{#{fetch(:rake)} db:seed}
	end
end
