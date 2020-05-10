module ReservationsLogHelper
  def log_personal_cancel( cancel )
    body = ""
    body = "【予約取消しました】" if cancel == true
  end
  def log_waiting( waiting )
    body = ""
    body = "【キャンセル待ちです】 " if waiting == true
  end
  def log_transfer( transfer )
    body = ""
    body = "【振替しました】 " if transfer == true
  end
  def log_absence( absence ) 
    body = ""
    body = "【欠席しました】" if absence == true
  end
  def log_cancel( cancel ) 
    body = ""
    body = "【授業が中止です】" if cancel == true
  end
end
