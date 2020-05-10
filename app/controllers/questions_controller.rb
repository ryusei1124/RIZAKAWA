class QuestionsController < ApplicationController
  before_action :set_question, only: %i(show destroy)
  before_action :unless_question, only: :show
  
  def index
    if current_user.admin?
      @questions = Question.paginate(page: params[:page], per_page: 10)
    else
      @questions = Question.where("user_id =? or destination =?", current_user.id, current_user.id).paginate(page: params[:page], per_page: 10)
    end
  end
  
  def show
    question_id = params[:id]
    @answers = Answer.where("question_id = ?" , question_id)
  end
  
  def new
    @question = Question.new
    if current_user.admin?
      @students = Student.kanaorder
      @users = User.undercontract
    else
      @students = Student.kanaorder.where("user_id = ?", current_user.id)
    end
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
    
    
    # def unless_question
    #   question_id = params[:id]
    #   @question = Question.find(question_id) 
    #   #管理者じゃなく宛先もしくはuser_idが該当のユーザーじゃない場合　|| はor あんまり使ってないわかりやすいのでorやand使ってる
    #   if (@question.user_id != current_user.id || @question.destination != current_user.id) && !current_user.admin? || current_user
    #   # if @question.user_id != current_user.id && !current_user.admin? && @question.user_id != current_user.admin
    #     flash[:warning] = "ログインし直して下さい"#長らくログインしてなくてメールから来る場合があるのでやわらかい表現で
    #     #ログイン画面へ
    #     log_out
    #     redirect_to '/login'
    #   end
    # end
    
    # def unless_question
    #   @question = Question.find(params[:id])
    #   if current_user.admin? or @question.user.id == current_user.id or @question.destination == current_user.id

    #   else
    #     flash[:success] = "ログインしなおして下さい"
    #     log_out
    #     redirect_to login_url
    #   end 
    # end
    
    def unless_question
      @question = Question.find(params[:id])
      unless current_user.admin? or @question.user.id == current_user.id or @question.destination == current_user.id
        flash[:success] = "ログインしなおして下さい"
        log_out
        redirect_to login_url
      end 
    end
end
