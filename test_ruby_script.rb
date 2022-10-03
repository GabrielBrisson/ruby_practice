require 'mysql2'
require 'dotenv/load'
require 'byebug'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB09_LGN'], password: ENV['DB09_PWD'], database: "applicant_tests")

def clean_names(client)
  id = client.query('select id from hle_dev_test_gabriel').to_a
  candidate_office_names = client.query('select candidate_office_name from hle_dev_test_gabriel').to_a.map { |r| r['candidate_office_name'] }

  # No dots, repeated words etc
  candidate_office_names.map! { |clean_name| clean_name.gsub(/Highway highway|Hwy hwy/, 'Highway').gsub(/[H|h]wy/, 'Highway').gsub(/[T|t]wp/, 'Township').delete('.').gsub(/(\w.+?) \1/i, '\1') }

  candidate_office_names.each_with_index do |cn, i|

    # Lowercase all words, unless they come after a slash or after a comma.
    if cn.match(/[\/,]/)
      candidate_office_names = cn.downcase.match(/(.+?)(?<=[\/,])/).to_s
    else
      candidate_office_names = cn.downcase
    end

    # Anything after a comma gets put in parentheses.
    if cn.include?(',') && !cn.include?('/')
      candidate_office_names = cn.gsub(/(?=,),\s(.*)/, ' (\1)')
    elsif cn.include?(',') && cn.include?('/')
      word2 = '(\2)'
      word3 = '\3'
      candidate_office_names = cn.gsub(/(.*)(?=,),\s?(.*)(?=\/)(.*)/, "#{word3} #{$1.downcase} #{word2}").gsub(/[\/,]/, '')
    end

    # Anything after a slash gets moved to the front of the name and remains capitalized.
    if cn.include?('/') && !cn.include?(',')
      word2 = '\2'
      candidate_office_names = cn.gsub(/(.*)(?<=\/)(.*)/, "#{word2} #{$1.downcase.chop}").gsub(/(\w.+?) \1/i, '\1')
    end

    # County Clerk/Recorder/DeKalb County becomes ‘DeKalb County clerk and recorder’
    if cn.match(/County Clerk\/Recorder\/DeKalb County/)
      candidate_office_names = cn.gsub(/(\w+)\s.(\w+)\/.(\w+)\/(DeKalb).*/, '\4 \1 c\2 and r\3')
    end

    client.query("update hle_dev_test_gabriel set clean_name = \"#{candidate_office_names}\" where id = #{id[i]['id']}")

    client.query("update hle_dev_test_gabriel set sentence = \"The candidate is running for the #{candidate_office_names} office.\" where id = #{id[i]['id']}")
  end
end

clean_names(client)

