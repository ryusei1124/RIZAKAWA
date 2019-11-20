# coding: utf-8

User.create!(student: "Sample student",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password")

60.times do |n|
  guardian = "sampl-#{n+1}@email.com"
  student  = "samp-#{n+1}@email.com"
  sex = "男"
  school = "samp-#{n+1}"
  school_year = "1"
  zoom = 'false'
  real = 'false'
  fix_day = "月"
  fix_time = "23:00"
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(guardian: guardian,
               student: student,
               sex: sex,
               school: school,
               school_year: school_year,
               zoom: zoom,
               real: real,
               fix_day: fix_day,
               fix_time: fix_time,
               email: email,
               password: password,
               password_confirmation: password)
end