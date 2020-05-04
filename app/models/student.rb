class Student < ApplicationRecord
   belongs_to :user
   validates :birthday,  presence: true
   validates :student_name,  presence: true
   has_many :reservations, dependent: :destroy
   has_many :lessoncomments, dependent: :destroy
#   has_many :questions, dependent: :destroy
#   has_many :answers, dependent: :destroy
   attr_accessor :lesson_id
   attr_accessor :lesson_note
   scope :kanaorder , -> { where(withdrawal:nil).order(studentkana: :asc)}
   
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
    elsif  grade<=12 
      @grade="高#{(grade-9)}"
    else
      @grade="対象外"
    end
   end
    
end
