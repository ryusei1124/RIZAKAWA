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
  def daydis(d)
    dis=d.month+"月"+d.day+"日"
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
  
  def jrhigh(nowday)
    nowday=nowday.to_date
    if nowday.month.to_i<=3
      jhyear=nowday.year.to_i-14
    else 
      jhyear=nowday.year.to_i-13
    end
      jhdate=(jhyear.to_s+"/04/02").to_date
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
  
  class Listcollection
  attr_accessor :id,:dateweek
    def initialize(id,content)
      @id=id
      @content=content
    end
  end
  
end
