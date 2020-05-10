class NoticesController < ApplicationController
  before_action :set_notice, only: %i(edit show update destroy)
  before_action :set_student
  before_action :unless_login
  before_action :day_setting, only: %i(index)
  
  def index
    @notices = Notice.paginate(page: params[:page], per_page: 10)
    @reservations = Reservation.joins(:lesson).where('lessons.meeting_on >=? and reservations.user_id=?',@today,current_user.id).order(meeting_on: "ASC") 
    @students = Student.where("user_id = ?",current_user.id).where(withdrawal: nil)
  end
  
  def new
    @notice = Notice.new
  end
  
  def edit
  end
  
  def create
    @notice = Notice.new(notice_params)
    @notice.user_id=current_user.id
    if @notice.save
      flash[:success] = "タイトル名「#{@notice.notice_title}」を作成し、契約中の保護者全員にお知らせメールを送りました"
      title = "タイトル名「#{@notice.notice_title}」を作成しました。"
      content = "お知らせ情報を追加しました。下記を参照下さい。"
      link = "notices"
      User.sendmail_all_users( title, content, link )
      redirect_to notices_url
    else
      render :new
    end
  end
  
  def show
  end
  
  def update
    if @notice.update_attributes(notice_params)
      flash[:success] = "お知らせ情報を更新しました。"
      redirect_to notices_url
    else
      render :edit
    end
  end
  
  def destroy
    @notice.destroy
    flash[:success] = "タイトル名「#{@notice.notice_title}」のデータを削除しました。"
    redirect_to notices_url
  end
  
  private
    
    def notice_params
      params.require(:notice).permit(:notice_title, :notice_content)
    end
    
    def set_notice
      @notice = Notice.find(params[:id])
    end
end
