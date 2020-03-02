module ApplicationHelper
  def full_title(page_name = "")
    base_title = "RIZAKAWA"
    if page_name.empty?
      base_title
    else
      page_name + " | " + base_title
    end
  end
  def hourdisplay(datetime)
    if datetime.hour<10
      result="0"+datetime.hour.to_s
    else
      result=datetime.hour.to_s
    end
    result
  end
  def mindisplay(datetime)
    if datetime.min<10
      result="0"+datetime.min.to_s
    else
      result=datetime.min.to_s
    end
    result
  end
  def timedisplay(datetime)
    hourdisplay(datetime).to_s+":"+mindisplay(datetime).to_s
  end
  def weekdate(d)
    if d.present?
      youbi = %w[日 月 火 水 木 金 土]
      youbi[d.wday]
    end
  end
  def timeselect(start,finish)
    timese=[]
    (start..finish).each do |time|
      timese.push(time.to_s+":"+"00")
      timese.push(time.to_s+":"+"30")
    end
    timese
  end
<<<<<<< HEAD
  def school_grade(bornday,nowday)
    bornday=bornday.to_date
    nowday=nowday.to_date
    if nowday.month.to_i<=3
      jhyear=nowday.year.to_i-16
      elyear=nowday.year.to_i-8
    else 
      jhyear=nowday.year.to_i-15
      elyear=nowday.year.to_i-7
    end
      jh=(jhyear.to_s+"/04/01").to_date
      jhf=((jhyear+6).to_s+"/03/31").to_date
      el=(elyear.to_s+"/04/01").to_date
      elf=((elyear+3).to_s+"/04/01").to_date
    #bornday 2010
    #jh 2004
    #el 2012
    if bornday>el && bornday<=elf
      kekka="小学生"
    elsif bornday>jh && bornday<=jhf
      kekka="中学生"
    else
      kekka="対象外"
    end
    kekka
  end
  def jrhigh(nowday)
    nowday=nowday.to_date
    if nowday.month.to_i<=3
      jhyear=nowday.year.to_i-14
    else 
      jhyear=nowday.year.to_i-13
    end
      jhdate=(jhyear.to_s+"/04/01").to_date
  end
=======
  
  # お知らせ詳細ページ「内容」の改行適用
  def nl2br(str)
    h(str).gsub(/\R/, "<br>")
  end
  
>>>>>>> d06ee3f8ce0690709d2335c713049dd06bc63f06
end
