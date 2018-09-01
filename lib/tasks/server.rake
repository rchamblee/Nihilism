namespace :server do
  desc "Deploy the server to production"
  task deploy: :environment do
    if ENV['SECRET_KEY_BASE'].nil?
      puts "Please run with SECRET_KEY_BASE set like so:\n\trake server:deploy SECRET_KEY_BASE=<SECRET_KEY>"
    else
      # In future we need to set it up so static assets are served externally
      printf `RAILS_ENV=production rake assets:clean assets:precompile db:migrate`
      printf `RAILS_ENV=production SECRET_KEY_BASE=#{ENV['SECRET_KEY_BASE']} rails s -d -p 80 -b 0.0.0.0 -e production`
    end
  end

  desc "Deploy the server in development mode"
  task dev: :environment do
    printf `rake assets:clean assets:precompile db:migrate`
    printf `rails s -p 3000`
  end

  desc "Kill the server"
  task kill: :environment do
    printf `kill #{`cat tmp/pids/server.pid`}`
  end
end
