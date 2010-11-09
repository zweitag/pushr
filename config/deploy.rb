# -*- encoding : utf-8 -*-
set :application, "pushr"
set :repository,  "git@github.com:zweitag/pushr.git"

set :scm, "git"
set :branch, "master"

set :deploy_via, :remote_cache

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :use_sudo, false

task :sentres do

  set :user, "ext-pushr"

  server "pushr.sentres.com", :app, :primary => true
  set :deploy_to, "/var/www/pushr.sentres.com"

end

namespace :deploy do
  task :setup, :except => { :no_release => true } do
    dirs = [releases_path, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
  end
  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  after "deploy:setup" do
    run "rm -r #{current_path}; true" # don't fail on failure
  end

  after "deploy:update_code" do
    run "ln -sf #{shared_path}/config/* #{release_path}"
  end
end
