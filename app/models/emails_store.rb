class EmailsStore < BasicStore
  def self.shared
    @shared ||= EmailsStore.new
  end

  def emails
    all('Email')
  end
  
  def create_email
    email = create_managed_object_for_key('Email')
    email.email = ''
    email
  end  

  def save_email(email)
    merge_new(email) unless email.email == ""
    persist
  end
  
  private

  def initialize
    super(['Email'], 'Emails.sqlite')
  end
end
