class ReservationusersController < ApplicationController
  include ApplicationHelper
  #before_action :unless_login
  before_action :unless_login_lessondetail, only: [:useredit]
  before_action :unless_student,   only: [:useredit]
  before_action :weekday,   only: [:useredit]
  before_action :mail_link_host,   only: [:reservation_create, :reservation_change_user, :reservation_delete]
  require 'date'
  
  def useredit
    useredit_reserve
  end

  def userupdate
    reservation_id=params[:reservation_id]
    if params[:commit] == "リアルに変更する"
      @zoom = false
    else
      @zoom = true
    end
    @reservation = Reservation.find(reservation_id)
    @reservation.zoom = @zoom
    @reservation.save
    waiting_registration
    if @reservation.save
      flash[:success] = "受講方法を変更しました"
    else
      flash[:danger] = "受講方法に失敗しました。"
    end 
    redirect_to request.referrer
  end
  
  def reservation_change_user
    reservation_id = params[:reservation_id]
    transfer_day_id = params[:id]
    @reservation = Reservation.find(reservation_id)
    @lesson = Lesson.find(@reservation.lesson_id)
    @lesson_meeting_on = @lesson.meeting_on
    student_id = params[:student_id]
    reservationarray = transfer_day_id.split("-")
    @reservation.lesson_id = reservationarray[0].to_i
    @reservation.lesson_id = reservationarray[0].to_i
    if reservationarray[1] == "1"
      @reservation.zoom = false
    else
      @reservation.zoom = true
    end
    @reservation.fix_time = nil
    @reservation.transfer = true
    @reservation.cancel = false
    if @reservation.note.present?
      @reservation.note = @reservation.note + " " + l(@lesson_meeting_on.to_datetime, format: :day_week) + "分の振替です"
    else
      @reservation.note = l(@lesson_meeting_on.to_datetime, format: :day_week)  + "分の振替です"
    end
    @reservation.save
    #キャンセル待ち登録
    waiting_registration
    if @reservation.save
      flash[:success] = "受講日振替をおこない、メールを送信しました。"
      @title = "予約の振替がありました"
      @content = "予約の振替がありました。"
      send_mail_address
      flash[:warning] = "キャンセル待ちになります。メールを送信しました" if @reservation.waiting == true
    else
      flash[:danger] = "受講日振替に失敗しました"
    end
    redirect_to "/reservationusers/useredit?lesson_id=#{@reservation.lesson_id}&student_id=#{student_id}"
  end

  def reservation_delete
    cancel = params[:cancel]
    reservation_id = params[:reservation_id]
    @reservation = Reservation.find(reservation_id)
    if cancel == "true"
    #予約情報をキャンセル登録
      @reservation.cancel = true
    #キャンセル待ちも解除する
      @reservation.waiting = false
    else
      @reservation.fix_time = nil
      @reservation.cancel = false 
    end
    if @reservation.save and @reservation.cancel?
      @title = "予約の取消しがありました"
      @content = "予約の取消しがありました。"
      send_mail_address
      flash[:warning] = "予約取消し、メールを送信しました"
    elsif @reservation.save and @reservation.cancel == false
      flash[:success] = "予約再開しました"
      @title = "予約の再開がありました"
      @content = "予約の再開がありました。"
      send_mail_address
      #キャンセル待ち登録
      waiting_registration
      if @reservation.save and @reservation.waiting?
        flash[:warning] = "キャンセル待ちになります"
      end
    else
      flash[:danger] = "取消失敗しました"
    end
    redirect_to request.referrer
  end
  
  def reservationnewuser
    @reservation = Reservation.new
    @student_id = params[:student_id]
    @student = Student.find(@student_id)
    @lesson_id = params[:lesson_id]
    @lesson = Lesson.find(@lesson_id)
    @lessoncomments = Lessoncomment.where("lesson_id =? and student_id=?" ,@lesson.id,@student.id)
    @realseat=@lesson.seats_real
    @realnumber=Reservation.where(" lesson_id=? AND zoom  = ?" ,@lesson.id, false).cancel_exclusion.count
    @zoom=true if @student.zoom?
    @zoomseat=@lesson.seats_zoom
    @zoomnumber=Reservation.where(" lesson_id=? AND zoom  = ?" ,@lesson.id, true).cancel_exclusion.count
    @real_rest_sheet = @realseat - @realnumber
    @zoom_rest_sheet = @zoomseat - @zoomnumber
  end
  
  def reservation_create
    student = Student.find(params[:student_id])
    @lesson = Lesson.find(params[:lesson_id])
    fix_time = params[:fix_time]
    zoom = tob(params[:zoom])
    user_id = student.user_id
    if Reservation.where("lesson_id = ? and student_id = ?",@lesson.id,student.id).count > 0
      flash[:danger] = "登録が重複してます。処理を中止しました。"
      redirect_to request.referrer and return
    end
    #定例授業の場合キャンセル登録ポイントマイナス１
    #student.cancelnumber=student.cancelnumber-1 if lesson.regular==true
    @reservation = Reservation.new(student_id:student.id,lesson_id:@lesson.id,zoom:zoom,user_id:user_id,fix_time:fix_time)
    @reservation.save
    waiting_registration
    if @reservation.save
      flash[:success] = "予約登録し、メールを送信しました"
      message = ""
      if @reservation.waiting?
        message = "キャンセル待ちになります。"
        flash[:warning] = "キャンセル待ちになります。" if @reservation.waiting == true
      end
      @title = "予約追加登録"
      @content = "予約の追加登録をしました。#{message}"
      send_mail_address
    else
      flash[:danger] = "受講日登録に失敗しました"
    end
    if current_user.admin?
      redirect_to request.referrer
    else
      redirect_to "/reservationusers/useredit?lesson_id=#{@reservation.lesson_id}&student_id=#{student.id}"
    end
  end

  private
    def useredit_reserve
      @lessonlists=[]
      session[:student_id] = @student.id
      @lesson = Lesson.find(@lesson_id)
      @lessons = Lesson.includes(:reservations).all
      @reservation = Reservation.find_by(lesson_id:@lesson.id, student_id:@student.id)
      @zoomnumber = Reservation.where(" lesson_id=? AND zoom  = ?" ,@lesson.id, true).cancel_exclusion.count
      @realnumber = Reservation.where(" lesson_id=? AND zoom  = ?" ,@lesson.id, false).cancel_exclusion.count
      @today = Date.today
      @lessoncomment = Lessoncomment.new
      #コメント抽出
      @lessoncomments = Lessoncomment.where("reservation_id = ? and student_id= ?" , @reservation.id, @student.id)
      #振替のためのコード。授業の日に該当生徒が小学生か中学生かを取得。
      gradesc = gradeschool(@student.birthday,@lesson.meeting_on)
      lessons = Lesson.where("meeting_on> ? and regular= ? and cancel = ?", @today,true,false).where("target= ? or target= ?", gradesc,"小中高生").where("examinee is null or examinee= ?",@student.examinee) .order(:meeting_on).order(:started_at)
      lessons.each do |les|
      if Reservation.where("student_id= ? and lesson_id= ?", @student.id,les.id).count == 0
        realcapacity = Lesson.find(les.id).seats_real
        capacity = "〇"
        capacity = "✖" if (realcapacity - Reservation.where("lesson_id= ? and zoom=?",les.id,false).count) <= 0
        content = capacity + l(les.meeting_on.to_datetime, format: :day_week) + l(les.started_at, format: :time)+"～"+l(les.finished_at, format: :time) + "リアル"
        @lessonlists << Listcollection.new(les.id.to_s+"-1",content,false)
        zoomcapacity = Lesson.find(les.id).seats_zoom
        capacity = "〇"
        capacity = "✖" if (zoomcapacity-Reservation.where("lesson_id = ? and zoom =?",les.id,true).count) <= 0
        content = capacity + l(les.meeting_on.to_datetime, format: :day_week) + l(les.started_at, format: :time)+"～"+l(les.finished_at, format: :time) + "ZOOM"
        @lessonlists << Listcollection.new(les.id.to_s+"-2",content,true)
      end
      end
    end

    def waiting_registration
      @zoom = @reservation.zoom
      @lesson = Lesson.find(@reservation.lesson_id) 
      if @zoom == true and @lesson.seats_zoom < Reservation.where("lesson_id = ? and zoom = ?", @lesson.id, true).cancel_exclusion.count 
        @reservation.waiting = true
      elsif @lesson.seats_real < Reservation.where("lesson_id = ? and zoom = ?", @lesson.id, false).cancel_exclusion.count
        @reservation.waiting = true
      else 
        @reservation.waiting = false
      end
    end
  
    def send_mail_address
      if current_user.admin?
        @destination_user = User.find( @reservation.user_id )
        @bcc = current_user.email
      else
        @destination_user = User.find(1)
        @bcc = ""
      end
      @send_user =  current_user
      link = "reservationusers/useredit?reservation_id=#{@reservation.id}&student_id=#{@reservation.student_id}"
      @link = @url + link
      ＃UserMailer.send_mail( @destination_user, @send_user, @bcc, @title, @content,@link).deliver_now
    end
end