class EmailsStore < BasicStore
  def self.shared
    @shared ||= EmailsStore.new
  end

  def emails
    all('Email')
  end
  
  def groups
    all('Group')
  end
  
  def create_email
    email = create_managed_object_for_key('Email')
    email.email = ''
    email
  end
  
  def create_group
    group = create_managed_object_for_key('Group')
    group.name = ''
    group
  end

  def save_email(email)
    merge_new(email) unless email.email == ""
    persist
  end
  
  def save_group(group)
    merge_new(group) unless group.name == ''
    persist
  end
  
  private

  def initialize
    super(['Email', 'Group'], 'Emails.sqlite')
    
    if groups == []
      puts "No groups found. Creating default group 'Work'"
      work = create_group
      work.name = 'Work'
      save_group(work)
    end
  end
end
