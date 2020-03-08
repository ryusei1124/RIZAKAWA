# coding: utf-8

User.create!(guardian: "sample",guardiankana:"サンプル",email: "sample@email.com",password: "password",password_confirmation: "password",admin: true)
User.create!(guardian:"山田太郎",guardiankana:"ヤマダタロウ",email:"sample-1@email.com",password:"password",password_confirmation:"password")
User.create!(guardian:"木村喜朗",guardiankana:"キムラヨシロウ",email:"sample-2@email.com",password:"password",password_confirmation:"password")
User.create!(guardian:"高田史郎",guardiankana:"タカダシロウ",email:"sample-3@email.com",password:"password",password_confirmation:"password")
User.create!(guardian:"佐藤武雄",guardiankana:"サトウタケオ",email:"sample-4@email.com",password:"password",password_confirmation:"password")
User.create!(guardian:"杉村紀子",guardiankana:"スギムラノリコ",email:"sample-5@email.com",password:"password",password_confirmation:"password")
User.create!(guardian:"伊藤七海",guardiankana:"イトウナナミ",email:"sample-6@email.com",password:"password",password_confirmation:"password")
User.create!(guardian:"工藤幸子",guardiankana:"クドウサチコ",email:"sample-7@email.com",password:"password",password_confirmation:"password")
User.create!(guardian:"斎藤雅美",guardiankana:"サイトウマサミ",email:"sample-8@email.com",password:"password",password_confirmation:"password")
User.create!(guardian:"太田祐樹",guardiankana:"オオタユウタ",email:"sample-9@email.com",password:"password",password_confirmation:"password")
User.create!(guardian:"古川真由美",guardiankana:"フルカワマユミ",email:"sample-10@email.com",password:"password",password_confirmation:"password")

Student.create!(student_name:"山田良子",studentkana:"ヤマダヨシコ",real:TRUE,zoom:FALSE,birthday:"2004/4/10",fix_day:"月",fix_time:"19:10",user_id:2)
Student.create!(student_name:"山田太郎",studentkana:"ヤマダタロウ",real:TRUE,zoom:FALSE,birthday:"2010/4/10",fix_day:"火",fix_time:"16:10",user_id:2)
Student.create!(student_name:"山田次郎",studentkana:"ヤマダジロウ",real:TRUE,zoom:FALSE,birthday:"2011/4/10",fix_day:"月",fix_time:"16:10",user_id:2)
Student.create!(student_name:"木村花",studentkana:"キムラハナ",real:TRUE,zoom:FALSE,birthday:"2006/10/24",fix_day:"火",fix_time:"19:20",user_id:3)
Student.create!(student_name:"高田義男",studentkana:"タカダヨシオ",real:TRUE,zoom:FALSE,birthday:"2009/11/24",fix_day:"月",fix_time:"16:25",user_id:4)
Student.create!(student_name:"高田真由",studentkana:"タカダマユ",real:TRUE,zoom:FALSE,birthday:"2010/12/24",fix_day:"金",fix_time:"16:30",user_id:4)
Student.create!(student_name:"佐藤良子",studentkana:"サトウヨシコ",real:TRUE,zoom:FALSE,birthday:"2004/4/10",fix_day:"月",fix_time:"19:30",user_id:5)
Student.create!(student_name:"佐藤太郎",studentkana:"ヤマダタロウ",real:TRUE,zoom:FALSE,birthday:"2010/4/10",fix_day:"金",fix_time:"16:45",user_id:5)
Student.create!(student_name:"杉村都和",studentkana:"スギムラトワ",real:TRUE,zoom:FALSE,birthday:"2011/4/10",fix_day:"火",fix_time:"16:10",user_id:6)
Student.create!(student_name:"伊藤千佳",studentkana:"イトウチカ",real:FALSE,zoom:TRUE,birthday:"2004/10/24",fix_day:"水",fix_time:"19:05",user_id:7)
Student.create!(student_name:"伊藤裕",studentkana:"イトウヒロシ",real:FALSE,zoom:TRUE,birthday:"2009/11/24",fix_day:"火",fix_time:"16:25",user_id:7)
Student.create!(student_name:"工藤奈々",studentkana:"クドウナナ",real:TRUE,zoom:FALSE,birthday:"2010/12/24",fix_day:"土",fix_time:"10:30",user_id:8)
Student.create!(student_name:"工藤勉",studentkana:"クドウベン",real:TRUE,zoom:FALSE,birthday:"2010/12/24",fix_day:"日",fix_time:"10:30",user_id:8)
Student.create!(student_name:"工藤奈々",studentkana:"クドウナナ",real:TRUE,zoom:FALSE,birthday:"2010/12/24",fix_day:"土",fix_time:"10:30",user_id:8)
Student.create!(student_name:"斎藤元気",studentkana:"サイトウゲンキ",real:TRUE,zoom:FALSE,birthday:"2005/12/24",fix_day:"日",fix_time:"13:36",user_id:9)
Student.create!(student_name:"斎藤裕子",studentkana:"サイトウユウコ",real:TRUE,zoom:FALSE,birthday:"2012/12/24",fix_day:"土",fix_time:"10:30",user_id:9)
Student.create!(student_name:"太田沙",studentkana:"オオタサち",real:TRUE,zoom:FALSE,birthday:"2005/12/24",fix_day:"月",fix_time:"19:36",user_id:10)
Student.create!(student_name:"太田仁",studentkana:"オオタジン",real:TRUE,zoom:FALSE,birthday:"2012/12/24",fix_day:"土",fix_time:"10:30",user_id:10)
Student.create!(student_name:"古川那奈",studentkana:"フルカワサチ",real:FALSE,zoom:TRUE,birthday:"2005/12/24",fix_day:"火",fix_time:"19:36",user_id:11)
Student.create!(student_name:"古川一花",studentkana:"フルカワイチカ",real:FALSE,zoom:TRUE,birthday:"2012/12/24",fix_day:"土",fix_time:"10:30",user_id:11)

61.times do |n|
  notice_title = "sample-#{n+1}タイトル"
  notice_content = "sample-#{n+1}内容"
  Notice.create!(notice_title: notice_title,
                 notice_content: notice_content,user_id:1)
             
end