class BasicStore < NSObject
  
  def initialize(entity_names, db_file_name)
    model = model_restricted_to_entities_named(entity_names)

    store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', db_file_name))
    
    store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
    error_ptr = Pointer.new(:object)
    unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:store_url, options:std_lightweight_migration_options, error:error_ptr)
      raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
    end

    context = NSManagedObjectContext.alloc.init
    context.persistentStoreCoordinator = store
    @cache = {}
    @context = context
  end

  def all(entity_name)
    @cache[entity_name] ||= begin
      request = NSFetchRequest.alloc.init
      request.entity = NSEntityDescription.entityForName(entity_name, inManagedObjectContext:@context)

      error_ptr = Pointer.new(:object)
      data = @context.executeFetchRequest(request, error:error_ptr)
      if data == nil
        raise "Error when fetching data: #{error_ptr[0].description}"
      end
      data
    end
  end
  
  def create_managed_object_for_key(key)
    model = @context.persistentStoreCoordinator.managedObjectModel
    desc = model.entitiesByName.objectForKey(key)
    NSManagedObject.alloc.initWithEntity(desc, insertIntoManagedObjectContext:nil)
  end
  
  private
  def model_restricted_to_entities_named(names_arr)
    m = NSManagedObjectModel.mergedModelFromBundles(nil)
    m.entities = m.entities.select{|e| names_arr.include?(e.name)}
    m
  end

  def std_lightweight_migration_options
    {
      NSMigratePersistentStoresAutomaticallyOption => 1,
      NSInferMappingModelAutomaticallyOption => 1
    }
  end
end