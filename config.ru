Encoding.default_external = 'utf-8'
$LOAD_PATH << File.dirname( File.expand_path(__FILE__) )
require 'pushr'

set :app_file,         'pushr.rb'
set :environment,      :production

disable :run, :reload
 
run Sinatra::Application
