class StatisticsStore < NSObject
  def self.shared
    @shared ||= StatisticsStore.new
  end

  def lates
    @lates ||= begin
      request = NSFetchRequest.alloc.init
      request.entity = NSEntityDescription.entityForName('Late', inManagedObjectContext:@context)

      error_ptr = Pointer.new(:object)
      data = @context.executeFetchRequest(request, error:error_ptr)
      if data == nil
        raise "Error when fetching data: #{error_ptr[0].description}"
      end
      data
    end
  end
  
  def sicks
    @sicks ||= begin
      request = NSFetchRequest.alloc.init
      request.entity = NSEntityDescription.entityForName('Sick', inManagedObjectContext:@context)

      error_ptr = Pointer.new(:object)
      data = @context.executeFetchRequest(request, error:error_ptr)
      if data == nil
        raise "Error when fetching data: #{error_ptr[0].description}"
      end
      data
    end
  end
  
  def histogram
    lates = day_of_week_counts(self.lates.collect(&:date))
    outs = day_of_week_counts(self.sicks.collect(&:date))
    
    {
      range: [0, range_from(lates, outs)],
      lates: lates,
      outs: outs
    }
  end
  
  def day_of_week_counts(dates)
    result = {sunday:0, monday:0, tuesday:0, wednesday:0, thursday:0, friday:0,  saturday:0}
    dates.each do |date|
      symbol = [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday][date.wday]
      result[symbol] += 1
    end
    
    result
  end
  
  def range_from(lates, outs)
    possible_ranges = [1, 2, 3, 5, 8, 13, 20, 50, 100, 200, 366]
    maximum = [lates.values.max, outs.values.max].max
    possible_ranges.select {|u| u > maximum}.first
  end
    
  def lates_this_month
    ailments_this_month("Late")
  end  
  
  def lates_this_year
    ailments_this_year("Late")
  end
  
  def sicks_this_month
    ailments_this_month("Sick")
  end

  def sicks_this_year
    ailments_this_year("Sick")
  end  
  
  def create_late(time)
    model = @context.persistentStoreCoordinator.managedObjectModel
    edesc = model.entitiesByName.objectForKey('Late')
    late = NSManagedObject.alloc.initWithEntity(edesc, insertIntoManagedObjectContext:nil)
    late.date = NSDate.alloc.init
    late.how_late = time
    
    late
  end  

  def create_sick
    model = @context.persistentStoreCoordinator.managedObjectModel
    edesc = model.entitiesByName.objectForKey('Sick')
    sick = NSManagedObject.alloc.initWithEntity(edesc, insertIntoManagedObjectContext:nil)
    sick.date = NSDate.alloc.init
    
    sick
  end
  
  def save_entity(entity)
    if entity.new? and entity.date != nil
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
    @sicks = nil
    @lates = nil
  end
  

  def initialize
    model = NSManagedObjectModel.alloc.init
    model.entities = [Late.entity, Sick.entity]

    store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
    store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', 'Statistics.sqlite'))
    error_ptr = Pointer.new(:object)
    unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:store_url, options:nil, error:error_ptr)
      raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
    end

    context = NSManagedObjectContext.alloc.init
    context.persistentStoreCoordinator = store
    @context = context
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
