class NoticesController < ApplicationController
  before_action :set_notice, only: %i(edit show update destroy)
  
  def index
    
    @notices = Notice.paginate(page: params[:page], per_page: 10)
  end
  
  def new
    @notice = Notice.new
  end
  
  def edit
  end
  
  def create
    @notice = Notice.new(notice_params)
    if @notice.save
      flash[:success] = "タイトル名「#{@notice.notice_title}」を作成しました。"
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
