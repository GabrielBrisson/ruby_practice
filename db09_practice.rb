require 'mysql2'
require 'dotenv/load'
require_relative 'methods.rb'
require 'digest'
require 'time'


client = Mysql2::Client.new(host: "db09.blockshopper.com", username:ENV['DB09_LGN'], password:ENV['DB09_PWD'], database: "applicant_tests")

md5 = Digest::MD5.new

timer = Time.now

generate_people(10000,client)
puts Time.now - timer

client.close