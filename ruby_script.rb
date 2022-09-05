require 'mysql2'
require 'dotenv/load'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB09_LGN'], password: ENV['DB09_PWD'], database: "applicant_tests")

def create_table_montana(client)
  begin
    client.query("create table montana_public_district_report_card_uniq_dist_gabriel(
  id int primary key not null auto_increment,
  name varchar(100) not null,
  clean_name varchar(100),
  address varchar(100),
  city varchar(30),
  state char(2),
  zip int)")
  rescue Mysql2::Error => error
    puts error
  end
end

def insert_data_into_montana(client)
  client.query("insert into montana_public_district_report_card_uniq_dist_gabriel(name, address, city, state, zip)
                select distinct school_name, address, city, state, zip from montana_public_district_report_card")
end

def clean_name(client)
  results = client.query("select * from montana_public_district_report_card_uniq_dist_gabriel").to_a

  results.each do |row|
    client.query("update montana_public_district_report_card_uniq_dist_gabriel
                  set clean_name = '#{(row['name'] + ' District.')
                                                          .gsub(/(H S)/, 'High School')
                                                          .gsub(/(K-12)|(K-12 Schools)/, 'Public School')
                                                          .gsub(/(Elem)/, 'Elementary School')
                                                          .gsub(/(w+) \1/, '\1')}'
      where id = #{row['id']}")
  end
end

insert_data_into_montana(client)

clean_name(client)
