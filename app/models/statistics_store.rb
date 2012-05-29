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
  
  def lates_this_month
    request = NSFetchRequest.alloc.init
    request.entity = NSEntityDescription.entityForName('Late', inManagedObjectContext:@context)
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

  def lates_this_year
    request = NSFetchRequest.alloc.init
    request.entity = NSEntityDescription.entityForName('Late', inManagedObjectContext:@context)
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

  def sicks_this_month
    request = NSFetchRequest.alloc.init
    request.entity = NSEntityDescription.entityForName('Sick', inManagedObjectContext:@context)
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

  def sicks_this_year
    request = NSFetchRequest.alloc.init
    request.entity = NSEntityDescription.entityForName('Sick', inManagedObjectContext:@context)
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

end
