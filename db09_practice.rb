require 'mysql2'
require_relative 'methods.rb'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: 'loki', password: 'v4WmZip2K67J6Iq7NXC', database: "applicant_tests")

get_teacher(3, client)

client.close