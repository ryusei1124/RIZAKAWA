class QuestionsController < ApplicationController
  before_action :set_question, only: %i(show destroy)
  before_action :admin_user, only: :destroy
  
  def index
    @questions = Question.paginate(page: params[:page], per_page: 10)
    if logged_in?
      @question  = current_user.questions.build
    end
  end
  
  def show
  end
  
  def new
    @question = Question.new
    @students = Student.all
    @users = User.all
  end
  
  def create
    @question = current_user.questions.build(question_params)
    # ログインしているidが反映させる↓
    @question.user_id = current_user.id
    if @question.save
      flash[:success] = "送信しました"
      redirect_to questions_url
    else
      render :new
    end
  end
  
  def destroy
    @question.destroy
    flash[:success] = "タイトル名「#{@question.question_title}」を削除しました。"
    redirect_to questions_url
  end
  
   private
   
    def question_params
      params.require(:question).permit(:question_title, :question_content, :destination, :student_id)
    end
    
    def set_question
      @question = Question.find(params[:id])
    end
end
