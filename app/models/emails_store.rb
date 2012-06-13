class EmailsStore < BasicStore
  def self.shared
    @shared ||= EmailsStore.new
  end

  def emails
    all('Email')
  end
  
  def emails_in_group(group_name)
    emails.select {|e| e.group == group_name}
  end
  
  def groups
    all('Group')
  end

  def active_groups
    @cache['active_groups'] ||= groups.select {|g|
      !emails_in_group(g.name).empty?
    }
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
  
  def remove_group(group)
  end
  
  private

  def initialize
    super(['Email', 'Group'], 'Emails.sqlite')
    
    if groups == []
      puts "No groups found. Creating default groups 'Work' and 'Home'"
      work = create_group
      work.name = 'Work'
      save_group(work)
      
      home = create_group
      home.name = 'Home'
      save_group(home)
    end
  end
end
