class SettingsController < UIViewController
  def loadView
    super
  end
  
  def viewDidLoad
    @scroll_view = UIScrollView.alloc.initWithFrame([[0, 0],[view.frame.size.width, view.frame.size.height - 44]])
    @ui_view = UIView.alloc.initWithFrame([[0, 0],[view.frame.size.width, view.frame.size.height - 44]])
    @scroll_view.addSubview(@ui_view)
    
    self.title = "Settings"
    
    label = UILabel.new
    label.frame = [[20,20],[view.frame.size.width - 20 * 2, 40]]
    label.text = "Team Emails"
    label.textAlignment = UITextAlignmentCenter
    label.textColor = UIColor.whiteColor
    label.backgroundColor = UIColor.clearColor
    @ui_view.addSubview(label)
    
    @emailsTable = UITableView.alloc.initWithFrame([[20, 70], [view.frame.size.width - 20 * 2, (EmailsStore.shared.emails.length + 1) * standardCellHeight]], 
      style:UITableViewStylePlain)
    @emailsTable.layer.cornerRadius = 10
    @emailsTable.delegate = @emailsTable.dataSource = self
    @ui_view.addSubview(@emailsTable)
    
    view.addSubview(@scroll_view)
    recalculate_table_height
  end
  
  def tableView(tv, numberOfRowsInSection:section)
    EmailsStore.shared.emails.length + 1
  end

  def tableView(tv, cellForRowAtIndexPath:indexPath)
    
    cell = UITableViewCell.alloc.initWithStyle(
                  UITableViewCellStyleSubtitle,
                  reuseIdentifier:nil)
    
    textField = UIEmailTextField.alloc.initWithFrame([[0,0],[200,44]])
    textField.delegate = self
    if indexPath.row < EmailsStore.shared.emails.length
      textField.email = EmailsStore.shared.emails[indexPath.row]
    else
      textField.email = EmailsStore.shared.create_email()
    end
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
    if indexPath.row < EmailsStore.shared.emails.length and !@editing
      UITableViewCellEditingStyleDelete
    else
      UITableViewCellEditingStyleNone
    end
  end
  
  def tableView(tv, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath )
    if (editingStyle == UITableViewCellEditingStyleDelete)
      EmailsStore.shared.remove_email(EmailsStore.shared.emails[indexPath.row])
      tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
      recalculate_table_height
    end
  end
  
  def textFieldDidBeginEditing(textField)
    @editing = true
  end
  
  def textFieldDidEndEditing(textField)
    #TODO refactor this terrible code
    textField.email.email = textField.text
    EmailsStore.shared.save_email(textField.email)
    
    @emailsTable.reloadData
    recalculate_table_height
    @editing = false
  end
  
  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
  end
  
  def recalculate_table_height
    old_frame = @emailsTable.frame
    new_height = (EmailsStore.shared.emails.length + 1) * standardCellHeight
    @emailsTable.frame = [old_frame.origin, [old_frame.size.width, new_height]]
    bottom = @emailsTable.frame.origin.y + @emailsTable.frame.size.height
    
    @ui_view.frame = [@ui_view.frame.origin, 
                      [@ui_view.frame.size.width, 
                       [view.frame.size.height, bottom + 20].max]]
    
    @scroll_view.contentSize = @ui_view.frame.size
  end
  
end