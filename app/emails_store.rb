class EmailsStore
  def self.shared
    @shared ||= EmailsStore.new
  end

  def emails
    @emails ||= begin
      request = NSFetchRequest.alloc.init
      request.entity = NSEntityDescription.entityForName('Email', inManagedObjectContext:@context)

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
    email = NSManagedObject.alloc.initWithEntity(edesc, insertIntoManagedObjectContext:nil)
    email.email = ''
    email
  end  

  def remove_email(email)
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
