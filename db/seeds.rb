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
             birthday: "2000/02/02",
             password: "password",
             password_confirmation: "password",
             admin: true)
             
User.create!(guardian: "山田太郎",
             student: "山田次郎",
             email: "test-1@email.com",
             sex: "男",
             school: "sample",
             school_year: "1",
             zoom: 'false',
             real: 'true',
             fix_day: "月",
             fix_time: "19:00",
             birthday: "2006/02/02",
             password: "password",
             password_confirmation: "password",
             admin: false)
             
User.create!(guardian: "佐藤太郎",
             student: "佐藤次郎",
             email: "test-2@email.com",
             sex: "男",
             school: "sample",
             school_year: "1",
             zoom: 'false',
             real: 'true',
             fix_day: "月",
             fix_time: "19:00",
             birthday: "2010/02/02",
             password: "password",
             password_confirmation: "password",
             admin: false)

User.create!(guardian: "松井太郎",
             student: "松井次郎",
             email: "test-3@email.com",
             sex: "男",
             school: "sample",
             school_year: "1",
             zoom: 'false',
             real: 'true',
             fix_day: "火",
             fix_time: "16:30",
             birthday: "2006/02/02",
             password: "password",
             password_confirmation: "password",
             admin: false)
             
User.create!(guardian: "田中太郎",
             student: "田中花子",
             email: "test-4@email.com",
             sex: "女",
             school: "sample",
             school_year: "1",
             zoom: 'false',
             real: 'true',
             fix_day: "火",
             fix_time: "19:30",
             birthday: "2010/10/02",
             password: "password",
             password_confirmation: "password",
             admin: false)

User.create!(guardian: "江川太郎",
             student: "江川次郎",
             email: "test-5@email.com",
             sex: "男",
             school: "sample",
             school_year: "1",
             zoom: 'false',
             real: 'true',
             fix_day: "水",
             fix_time: "16:30",
             birthday: "2006/02/02",
             password: "password",
             password_confirmation: "password",
             admin: false)

User.create!(guardian: "鈴木太郎",
             student: "鈴木節子",
             email: "test-6@email.com",
             sex: "女",
             school: "sample",
             school_year: "1",
             zoom: 'true',
             real: 'false',
             fix_day: "水",
             fix_time: "19:30",
             birthday: "2010/10/02",
             password: "password",
             password_confirmation: "password",
             admin: false)

User.create!(guardian: "小泉太郎",
             student: "小泉次郎",
             email: "test-7@email.com",
             sex: "男",
             school: "sample",
             school_year: "1",
             zoom: 'false',
             real: 'true',
             fix_day: "金",
             fix_time: "16:30",
             birthday: "2006/02/02",
             password: "password",
             password_confirmation: "password",
             admin: false)

User.create!(guardian: "安田太郎",
             student: "安田節子",
             email: "test-8@email.com",
             sex: "女",
             school: "sample",
             school_year: "1",
             zoom: 'false',
             real: 'true',
             fix_day: "金",
             fix_time: "19:30",
             birthday: "2012/10/02",
             password: "password",
             password_confirmation: "password",
             admin: false)

User.create!(guardian: "堀江太郎",
             student: "堀江次郎",
             email: "test-9@email.com",
             sex: "男",
             school: "sample",
             school_year: "1",
             zoom: 'false',
             real: 'true',
             fix_day: "金",
             fix_time: "16:30",
             birthday: "2006/02/02",
             password: "password",
             password_confirmation: "password",
             admin: false)

User.create!(guardian: "小谷太郎",
             student: "小谷節子",
             email: "test-10@email.com",
             sex: "女",
             school: "sample",
             school_year: "1",
             zoom: 'false',
             real: 'true',
             fix_day: "金",
             fix_time: "19:30",
             birthday: "2012/10/02",
             password: "password",
             password_confirmation: "password",
             admin: false)

User.create!(guardian: "木村太郎",
             student: "木村次郎",
             email: "test-11@email.com",
             sex: "男",
             school: "sample",
             school_year: "1",
             zoom: 'false',
             real: 'true',
             fix_day: "土",
             fix_time: "16:30",
             birthday: "2007/02/02",
             password: "password",
             password_confirmation: "password",
             admin: false)

User.create!(guardian: "立花太郎",
             student: "立花節子",
             email: "test-12@email.com",
             sex: "女",
             school: "sample",
             school_year: "1",
             zoom: 'false',
             real: 'true',
             fix_day: '土',
             fix_time: "19:30",
             birthday: "2010/10/02",
             password: "password",
             password_confirmation: "password",
             admin: false)
             
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
  birthday = "2000/02/02"
  password = "password"
  User.create!(guardian: guardian,
               student: student,
               email: email,
               sex: sex,
               school: school,
               school_year: school_year,
               zoom: zoom,
               real: real,
               fix_day: fix_day,
               fix_time: fix_time,
               birthday: birthday,
               password: password,
               password_confirmation: password)
end
             
61.times do |n|
  notice_title = "sample-#{n+1}タイトル"
  notice_content = "sample-#{n+1}内容"
  Notice.create!(notice_title: notice_title,
                 notice_content: notice_content,
                 )
             
end
