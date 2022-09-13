require 'mysql2'
require 'dotenv/load'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB09_LGN'], password: ENV['DB09_PWD'], database: "applicant_tests")

client.query("insert into hle_dev_test_gabriel(id, candidate_office_name)
                 select * from hle_dev_test_candidates;")


