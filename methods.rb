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
      puts "#{row['first_name_initial']}. #{row['middle_name_initial']}. #{row['last_name']} (#{row['subject']})"
    end
  end
end