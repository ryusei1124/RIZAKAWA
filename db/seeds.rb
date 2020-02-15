# coding: utf-8

User.create!(guardian: "sample",
             student: "sample_student",
             email: "sample@email.com",
             sex: "男",
             school: "sample",
             school_year: "1",
             zoom: 'false',
             real: 'false',
             fix_day: "月",
             fix_time: "23:00",
             password: "password",
             password_confirmation: "password",
             admin: "true")

60.times do |n|
  guardian = Faker::Name.name
  student  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  sex = "男"
  school = "sample-#{n+1}"
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