class BasicInfosController < ApplicationController
  def student_update
    studentsmany_params.each{|id,val|birthday,school = val.values_at("birthday","school")
    @student = Student.find(id)
    @student.update(
        school:school,
        birthday:birthday)
    }
    flash[:success]="基本情報更新に成功しました"
    redirect_to request.referrer
  end
  private
  def studentsmany_params
    params.permit(studentsmany: [:birthday,:school])[:studentsmany]
  end
end
