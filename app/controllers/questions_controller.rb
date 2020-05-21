class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :destroy]
  before_action :unless_question, only: :show
  before_action :logged_in_user, only: [:show, :update, :index, :destroy]
  before_action :admin_user, only: :destroy
  
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
    # if current_user.admin?
    #   @students = Student.kanaorder
      @users = User.undercontract
    # else
    #   @students = Student.kanaorder.where("user_id = ?", current_user.id)
    # end
  end
  
  def create
    @question = Question.new(question_params)
    # ログインしているidが反映させる↓
    @question.user_id = current_user.id
    if @question.save
      @title = "お問い合わせの登録がありました"
      @content = "お問い合わせの登録がありました。下記リンクの確認をお願いします。"
      send_mail_address
      flash[:success] = "登録に成功し、通知メールを送信しました"
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
    
    def unless_question
      @question = Question.find(params[:id])
      unless current_user.admin? or @question.user.id == current_user.id or @question.destination == current_user.id
        flash[:success] = "ログインしなおして下さい"
        redirect_to login_url
      end 
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # システム管理権限所有かどうか判定します。
    def admin_user
      redirect_to root_url unless current_user.admin?
    end

    def send_mail_address
      if current_user.admin?
        @destination_user = User.find( @question.user_id )
        @bcc = current_user.email
      else
        @destination_user = User.find(1)
        @bcc = ""
      end
      @send_user =  current_user
      @link = "questions"
      UserMailer.send_mail( @destination_user, @send_user, @bcc, @title, @content,@link).deliver_now
    end
end
