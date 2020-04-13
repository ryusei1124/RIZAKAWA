class BasicInfosController < ApplicationController
  def student_update
    students = studentsmany_params
    students.each do | id, school |
      sc = students[id.to_s]["school"]
      @student = Student.find(id)
      @student.update(school:sc)
    end
    flash[:success] = "基本情報更新に成功しました"
    redirect_to request.referrer
  end
  private
  def studentsmany_params
    params.permit(studentsmany: [:school])[:studentsmany]
  end
end
