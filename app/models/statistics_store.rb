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
  
  def outs
    @outs ||= begin
      request = NSFetchRequest.alloc.init
      request.entity = NSEntityDescription.entityForName('Out', inManagedObjectContext:@context)

      error_ptr = Pointer.new(:object)
      data = @context.executeFetchRequest(request, error:error_ptr)
      if data == nil
        raise "Error when fetching data: #{error_ptr[0].description}"
      end
      data
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
    model = @context.persistentStoreCoordinator.managedObjectModel
    edesc = model.entitiesByName.objectForKey('Late')
    late = NSManagedObject.alloc.initWithEntity(edesc, insertIntoManagedObjectContext:nil)
    late.date = NSDate.alloc.init
    late.how_late = time
    
    late
  end  

  def create_out
    model = @context.persistentStoreCoordinator.managedObjectModel
    edesc = model.entitiesByName.objectForKey('Out')
    out = NSManagedObject.alloc.initWithEntity(edesc, insertIntoManagedObjectContext:nil)
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
    model = StoreHelper.model_restricted_to_entities_named(['Late', 'Out'])

    store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', 'Statistics.sqlite'))

    error_ptr = Pointer.new(:object)
    metadata = NSPersistentStoreCoordinator.metadataForPersistentStoreOfType(nil, URL:store_url, error:error_ptr)
    if !metadata.nil? && !model.isConfiguration(nil, compatibleWithStoreMetadata:metadata)
      migrate_to(model, store_url)
    end

    store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
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


  def migrate_to(dest_model, url)
    puts "STATISTICS_STORE MIGRATE_TO"
  end
end
