module ReservationsLogHelper
  def log_waiting( waiting )
    body = ""
    body = "キャンセル待ちです " if waiting == true
  end
  def log_transfer( transfer )
    body = ""
    body = "【振替しました】 " if transfer == true
  end
  def log_absence( absence ) 
    body = ""
    body = "欠席しました" if absence == true
  end
end
