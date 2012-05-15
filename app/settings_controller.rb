class SettingsController < UIViewController
  def loadView
    super
    @emails = ["abc@cyrus.com", "def@cyrus.com", "efg@cyrus.com", "asdfasf@abc.com"]
  end
  
  def viewDidLoad
    self.title = "Settings"
    
    label = UILabel.new
    label.frame = [[20,20],[view.frame.size.width - 20 * 2, 40]]
    label.text = "Team Emails"
    label.textAlignment = UITextAlignmentCenter
    label.textColor = UIColor.whiteColor
    label.backgroundColor = UIColor.clearColor
    view.addSubview(label)
    
    emailsTable = UITableView.alloc.initWithFrame([[20, 70], [view.frame.size.width - 20 * 2, @emails.length * standardCellHeight]], 
      style:UITableViewStylePlain)
    emailsTable.layer.cornerRadius = 10
    emailsTable.delegate = emailsTable.dataSource = self
    #emailsTable.addTarget(self, action:'rowDragged:forEvent:', forControlEvents:UIControlEventTouchDragInside)
    
    view.addSubview(emailsTable)
  end
  
  def tableView(tv, numberOfRowsInSection:section)
    @emails.length
  end

  def tableView(tv, cellForRowAtIndexPath:indexPath)
    
    cell = UITableViewCell.alloc.initWithStyle(
                  UITableViewCellStyleSubtitle,
                  reuseIdentifier:nil)
    
    textField = UITextField.alloc.initWithFrame([[0,0],[200,44]])
    textField.delegate = self
    textField.text = @emails[indexPath.row]
    textField.keyboardType = UIKeyboardTypeEmailAddress
    textField.returnKeyType = UIReturnKeyDone
    cell.addSubview(textField) 
    cell
  end
  
  def standardCellHeight
    44
  end
  
  def tableView(tv, canEditRowAtIndexPath:indexPath)
    #puts("canEditRowAtIndexPath")
    true
  end
  
  def tableView(tv, editingStyleForRowAtIndexPath:indexPath)
    #puts("editingStyle")
    UITableViewCellEditingStyleDelete
  end
  
  def tableView(tv, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath )
    if (editingStyle == UITableViewCellEditingStyleDelete)
      @emails.delete_at(indexPath.row)
      tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
      #TODO: change height after delete
    end
  end
  
  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
  end
  
end