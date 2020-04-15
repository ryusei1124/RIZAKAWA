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
    if datetime.present?
      hourdisplay(datetime).to_s+":" + mindisplay(datetime).to_s
    end
  end
  def daydis(d)
    dis=d.month.to_s+"月"+d.day.to_s+"日"
    dis
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
  def yearpiriod(date)
    date.to_date
    if (date.month.to_i<=3) or (date.month.to_i==4 and date.day.to_i==1)
      yearp=date.year.to_i-1
    else 
      yearp=date.year
    end
      yearp
  end
  
  def jrhigh(nowday)
    nowday=nowday.to_date
    if nowday.month.to_i<=3
      jhyear=nowday.year.to_i-13
    else 
      jhyear=nowday.year.to_i-12
    end
      jhdate=(jhyear.to_s+"/04/02").to_date
  end
  
  
  def grade(born,nowday)
    gradeyear=yearpiriod(nowday)-yearpiriod(born)
    gradeyear
  end
  def gradeschool(born,nowday)
    gradeyear=grade(born,nowday)
    if gradeyear<=12
      gradeschoolreturn="小学生"
    else
      gradeschoolreturn="中学生"
    end
    gradeschoolreturn
  end
  
  def tob(text)
    if text=="true"
      textreturn=true
    elsif text=="false"
       textreturn=false
    end
    textreturn
  end
  
  # お知らせ詳細ページ「内容」の改行適用
  def nl2br(str)
    h(str).gsub(/\R/, "<br>")
  end
  
  def holiday(d)
    holidayreturn=HolidayJapan.check(Date.new(d.year,d.month,d.day))
    holidayreturn
  end
  
  class Listcollection
  attr_accessor :id,:content
    def initialize(id,content,zoom)
      @id=id
      @content=content
    end
  end
  def tdbgcolor(thisday,day,section)
    if day==thisday && section==1
      bgcolor="#f5deb3"
    elsif day.wday==0  or holiday(day)
      bgcolor="#ffede6"
    elsif day.wday==6
      bgcolor="#e0ffff"
    elsif section==2
      bgcolor="#f5f5dc"
    else
      bgcolor="#fffafa"
    end
    bgcolor
  end
  def tdcellbgcolor(thisday,day,section)
    if day==thisday && section==1
      bgcolor="#e9967a"
    elsif day.wday==0  or holiday(day)
      bgcolor="#ffede6"
    elsif day.wday==6
      bgcolor="#e0ffff"
    elsif section==2
      bgcolor="#dcdcdc"
    else
      bgcolor="#fffafa"
    end
    bgcolor
  end
  def attend(zoom)
    if zoom==true
      result="Zoom"
    else
      result="リアル"
    end
  end
   def tasker(ex)
    if ex==true and ex.present?
      result="受験生"
    else
      result="一般"
    end
  end
end
