require 'mysql2'
require 'dotenv/load'
require_relative 'methods.rb'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username:ENV['DB09_LGN'], password:ENV['DB09_PWD'], database: "applicant_tests")

get_teacher(1, client)

client.close