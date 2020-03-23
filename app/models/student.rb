class Student < ApplicationRecord
   belongs_to :user
   def self.gradeyear(id)
    born=Student.find(id).birthday
    bornmonth=born.month
    bornday=born.day
    byear=born.year
    byear=byear-1 if bornmonth<=3 || (bornmonth==4 && bornday==1)
    nowmonth=Date.today.month
    nyear=Date.today.year
    nyear=Date.today.year-1 if nowmonth<=3
    grade=nyear-byear-6
    if grade<=6 && grade>0
      @grade="小#{(grade)}"
    elsif grade<=9 
      @grade="中#{(grade-6)}"
    else
      @grade="対象外"
    end
   end
    
end
