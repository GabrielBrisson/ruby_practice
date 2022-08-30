def get_teacher(id, client)
  f = "select first_name, middle_name, last_name, birth_date from teachers_gabriel where ID = #{id}"
  results = client.query(f).to_a
  if results.count.zero?
    puts "Teacher with ID #{id} was not found."
  else
    puts "Teacher #{results[0]['first_name']} #{results[0]['middle_name']} #{results[0]['last_name']} was born on #{(results[0]['birth_date']).strftime("%d %b %Y (%A)")}"
  end
end

def get_subject_teachers(id, client)
  f = "select  first_name, middle_name, last_name, subject.name as subject
  from teachers_gabriel teacher join subjects_gabriel subject on teacher.subject_id = subject.ID where subject.ID = #{id}";

  results = client.query(f).to_a

  output = ""
  if results.count.zero?
    output = "Not found any that teaches this subject."
  else
    output = "Subject: #{results[0]['subject']}\nTeachers:"
    results.each do |row|
      output += "#{row['first_name']} #{row['middle_name']} #{row['last_name']}\n"
    end
  end
  puts output
end

def get_class_subjects(class_name, client)
  f = "select subject.name as subject_name, first_name, substring(middle_name,1,1) as middle_name_initial, last_name
    from teachers_classes_gabriel tc
    join teachers_gabriel teacher on teacher.ID = tc.ID
    join subjects_gabriel subject on subject.ID = teacher.subject_id
    join classes_gabriel class on class.ID = tc.class_ID
    where class.name = #{class_name}"

  results = client.query(f).to_a

  output = ""
  if results.count.zero?
    output = "There are no teachers in class #{class_name}"
  else
    output = "Class: #{class_name}\nSubjects:\n"
    results.each do |row|
      output += "#{row['subject_name']}: #{row['first_name']}. #{row['middle_name_initial']}. #{row['last_name']}\n"
    end
  end
  puts output
end

def get_teachers_list_by_letter(letter, client)
  f = "select substring(first_name, 1, 1) as first_name_initial,
    substring(middle_name, 1, 1) as middle_name_initial,
    last_name,
    s.name as subject
    from teachers_gabriel t
    join subjects_gabriel s using(ID)
    where first_name regexp'#{letter}'
    or last_name regexp'#{letter}' "

  results = client.query(f).to_a
  if results.count.zero?
    puts "No teacher with the letter #{letter} in the first or last name"
  else
    results.each do |row|
      puts "#{row['first_name_initial']}. #{row['middle_name_initial']}. #{row['last_name']} (#{row['subject'] })"
    end
  end
end

def set_md5(md5, client)
  f = "select concat(
  first_name,
  middle_name,
  last_name,
  birth_date,
  subject_id) as teacher
  from teachers_gabriel"

  results = client.query(f).to_a

  id = 0
  results.each do |row|
    client.query("update teachers_gabriel set md5 = '#{md5.hexdigest(row.to_s)}' where id = #{id += 1}")
  end
end

def random_date(date_begin, date_end)
  puts rand(date_begin..date_end)
end

def random_last_names(times, client)
  f = "select last_name from last_names
  order by rand()
  limit #{times}"

  results = client.query(f).to_a

  output = ""
  if results.count.zero?
    output = "There are no last name to be selected!"
  else
    output = results.map { |row| row['last_name'] }
  end
  p output
end

def random_first_names(times, client)
  f = "select FirstNames from male_names
  union
  select names from female_names
  order by rand()
  limit #{times}"

  results = client.query(f).to_a

  output = ""
  if results.count.zero?
    output = "There are no first name to be selected!"
  else
    output = results.map { |row| row['FirstName'] }
  end
  p output
end

def generate_people(number, client)
  number.times do

    random_birth_date = random_date(1910, 2022)
    random_first_names = random_first_names(number, client)[0]
    random_last_names = random_last_names(number, client)[0]

    client.query("insert into random_people_gabriel(first_name, last_name, birth_date)
                values('#{random_first_names}', '#{random_last_names}', '#{random_birth_date}' )")
  end
end
