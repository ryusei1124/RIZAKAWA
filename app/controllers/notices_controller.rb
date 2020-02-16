class NoticesController < ApplicationController
  def index
    @notices = Notice.all
  end
  
  def new
    @notice = Notice.new
  end
  
  def create
    @notice = Notice.new(notice_params)
    if @notice.save
      flash[:success] = "お知らせ情報を作成しました。"
      redirect_to notices_url
    else
      render :new
    end
  end
  
  private
    
    def notice_params
      params.require(:notice).permit(:notice_title, :notice_content)
    end
    
    def set_notice
      @notice = Notice.find(params[:id])
    end
end
