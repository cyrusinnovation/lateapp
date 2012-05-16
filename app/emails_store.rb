class EmailsStore
  def self.shared
    # Our store is a singleton object.
    @shared ||= EmailsStore.new
  end

  def emails
    @emails ||= begin
      # Fetch all emails from the model, sorting by the creation date.
      request = NSFetchRequest.alloc.init
      request.entity = NSEntityDescription.entityForName('Email', inManagedObjectContext:@context)
      #request.sortDescriptors = [NSSortDescriptor.alloc.initWithKey('index', ascending:false)] 

      error_ptr = Pointer.new(:object)
      data = @context.executeFetchRequest(request, error:error_ptr)
      if data == nil
        raise "Error when fetching data: #{error_ptr[0].description}"
      end
      data
    end
  end
  
  def create_email
    model = @context.persistentStoreCoordinator.managedObjectModel
    edesc = model.entitiesByName.objectForKey('Email')
    NSManagedObject.alloc.initWithEntity(edesc, insertIntoManagedObjectContext:nil)
    #NSEntityDescription.insertNewObjectForEntityForName('Email', inManagedObjectContext:@context)
  end  

  def remove_email(email)
    # Delete the given entity, then save the model.
    @context.deleteObject(email)
    save
  end
  
  def save_email(email)
    if email.new? and email.email != ""
      @context.insertObject(email)
    end
    save
  end
  
  private

  def initialize
    # Create the model programmatically. Our model has only one entity, the Email class, and the data will be stored in a SQLite database, inside the application's Documents folder.
    model = NSManagedObjectModel.alloc.init
    model.entities = [Email.entity]

    store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
    store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', 'Emails.sqlite'))
    error_ptr = Pointer.new(:object)
    unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:store_url, options:nil, error:error_ptr)
      raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
    end

    context = NSManagedObjectContext.alloc.init
    context.persistentStoreCoordinator = store
    @context = context
  end

  def save
    error_ptr = Pointer.new(:object)
    unless @context.save(error_ptr)
      raise "Error when saving the model: #{error_ptr[0].description}"
    end
    @emails = nil
  end
end
