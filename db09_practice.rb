require 'mysql2'
require 'dotenv/load'
require_relative 'methods.rb'
require 'digest'
require 'time'


client = Mysql2::Client.new(host: "db09.blockshopper.com", username:ENV['DB09_LGN'], password:ENV['DB09_PWD'], database: "applicant_tests")

md5 = Digest::MD5.new


#get_teacher(1,client)

#get_subject_teachers(7,client)

#get_class_subjects(3001,client)

#get_teachers_list_by_letter("g",client)

#set_md5(md5, client)

#random_last_names(20, client)


client.close