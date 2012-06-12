class StatisticsStore < BasicStore
  def self.shared
    @shared ||= StatisticsStore.new
  end

  def lates
    @lates ||= begin
      find_all('Late')
    end
  end
  
  def outs
    @outs ||= begin
      find_all('Out')
    end
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
    out = create_managed_object_for_key('Late')
    out.date = NSDate.alloc.init
    
    out
  end
  
  def save_entity(entity)
    if entity.managedObjectContext.nil? and entity.date != nil
      @context.insertObject(entity)
    end
    save
  end

  private
  
  def save 
    error_ptr = Pointer.new(:object)
    unless @context.save(error_ptr)
      raise "Error when saving the model: #{error_ptr[0].description}"
    end
    @outs = nil
    @lates = nil
  end
  

  def initialize
    super(['Late', 'Out'], 'Statistics.sqlite')
  end


  def ailments_this_month(entity)
    request = NSFetchRequest.alloc.init
    request.entity = NSEntityDescription.entityForName(entity, inManagedObjectContext:@context)
    today = NSDate.alloc.init
    thirty_days_ago = today - (30 * 24 * 60 * 60)
    predicate = NSPredicate.predicateWithFormat("date >= %@ && date <= %@", argumentArray:[thirty_days_ago, today])
    request.setPredicate(predicate)

    error_ptr = Pointer.new(:object)
    data = @context.executeFetchRequest(request, error:error_ptr)
    if data == nil
      raise "Error when fetching data: #{error_ptr[0].description}"
    end
    data
  end
  
  def ailments_this_year(entity)
    request = NSFetchRequest.alloc.init
    request.entity = NSEntityDescription.entityForName(entity, inManagedObjectContext:@context)
    today = NSDate.alloc.init
    year_ago = today - (365 * 24 * 60 * 60)
    predicate = NSPredicate.predicateWithFormat("date >= %@ && date <= %@", argumentArray:[year_ago, today])
    request.setPredicate(predicate)

    error_ptr = Pointer.new(:object)
    data = @context.executeFetchRequest(request, error:error_ptr)
    if data == nil
      raise "Error when fetching data: #{error_ptr[0].description}"
    end
    data
  end
end
