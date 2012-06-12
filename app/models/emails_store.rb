class EmailsStore < BasicStore
  def self.shared
    @shared ||= EmailsStore.new
  end

  def emails
    @emails ||= begin
      find_all('Email')
    end
  end
  
  def create_email
    email = create_managed_object_for_key('Email')
    email.email = ''
    email
  end  

  def remove_email(email)
    @context.deleteObject(email)
    save
  end
  
  def save_email(email)
    if email.managedObjectContext.nil? and email.email != ""
      @context.insertObject(email)
    end
    save
  end
  
  private

  def initialize
    super(['Email'], 'Emails.sqlite')
  end

  def save
    error_ptr = Pointer.new(:object)
    unless @context.save(error_ptr)
      raise "Error when saving the model: #{error_ptr[0].description}"
    end
    @emails = nil
  end
end
