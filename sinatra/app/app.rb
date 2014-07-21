require 'sinatra'
require 'mysql'
require 'redis'
require 'yaml'
require 'time'

## Configuration for sinatra. Bind to port 8080 on all interfaces
set :bind, '0.0.0.0'
set :port, 8080
set :logging, true


## Establish connection to mysql... Determine host for mysql depending on how we run the containers
if (ENV['MYSQL_HOST'] != nil)
  # This is for host only ip and port forwarding cases
  mysql_host = ENV['MYSQL_HOST']
else
  # This is for link cases
  mysql_host = 'mysql'
end
retries = 5 # retries since mysql not be ready for connections yet
while retries > 0
  begin
    $mysql = Mysql.real_connect(mysql_host, 'dockerexample', 'dockerexample', 'dockerexample')
    retries = 0
    puts "Mysql connect!"
  rescue
    puts "Mysql connect failed... wait 3 seconds and retry"
    retries -= 1
    sleep 3
  end
end

## Establish connection to redis... Determine host for redis depending on how we run the containers
if (ENV['REDIS_HOST'] != nil)
  # This is for host only ip and port forwarding cases
  redis_host = ENV['REDIS_HOST']
else
  # This is for link cases
  redis_host = 'redis'
end
retries = 5 # retries since redis not be ready for connections yet
while retries > 0
  begin
    $redis = Redis.new(:host => redis_host, :port => 6379)
    retries = 0
    puts "Redis connect!"
  rescue
    puts "Redis connect failed... wait 3 seconds and retry"
    retries -= 1
    sleep 3
  end
end


## App Endpoints
get '/ping' do
  'pong'
end

get '/' do

  # Who is the visitor (browser)
  currentVisitor = "Client Ip=" + request.ip.to_s + "(ts: " + Time.now.to_s + ")"

  ## Do a simple redis operation... Get / Set timestamp and client ip
  lastVisitor = $redis.get('lastvisitor')
  $redis.set('lastvisitor',currentVisitor)

  ## Get client ip address for redis connection
  redisClient = $redis.client("list")[0]["addr"]

  ## Get client ip address for mysql connection
  rs = $mysql.query ("select host from information_schema.processlist WHERE ID=connection_id();")
  mysqlClient = rs.fetch_row[0]

  ## Write output
  stream do |out|
    out << "<PRE>"

    out << "Current visitor: " + currentVisitor + "\n"
    if(lastVisitor != nil)
      out << "Last visitor: " + lastVisitor + "\n"
    end

    out << "\nRedis host: " + redis_host + "\n"
    out << "  this connection client: " + redisClient.to_s + "\n"
    out << "Mysql host: " + mysql_host + "\n"
    out << "  this connection client: " + mysqlClient.to_s + "\n\n"

    out << "</PRE>"
  end
end
