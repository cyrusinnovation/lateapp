class StatisticsStore < BasicStore
  def self.shared
    @shared ||= StatisticsStore.new
  end

  def lates
    all('Late')
  end
  
  def outs
    all('Out')
  end

  
  def lates_this_month
    ailments_this_month("Late")
  end  
  
  def lates_this_year
    ailments_this_year("Late")
  end
  
  def outs_this_month
    ailments_this_month("Out")
  end

  def outs_this_year
    ailments_this_year("Out")
  end  
  
  def create_late(time)
    late = create_managed_object_for_key('Late')
    late.date = NSDate.alloc.init
    late.how_late = time
    
    late
  end  

  def create_out
    out = create_managed_object_for_key('Out')
    out.date = NSDate.alloc.init
    
    out
  end
  
  def save_entity(entity)
    merge_new(entity) unless entity.date.nil?
    persist
  end

  private

  def initialize
    super(['Late', 'Out'], 'Statistics.sqlite')
  end


  def ailments_this_month(ailment_name)
    today = NSDate.alloc.init
    thirty_days_ago = today - (30 * 24 * 60 * 60)
    fetch(ailment_name, "date >= %@ && date <= %@", [thirty_days_ago, today])
  end
  
  def ailments_this_year(ailment_name)
    today = NSDate.alloc.init
    year_ago = today - (365 * 24 * 60 * 60)
    fetch(ailment_name, "date >= %@ && date <= %@", [year_ago, today])
  end
end
