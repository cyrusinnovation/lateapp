class SettingsController < UITableViewController
  def loadView
    self.tableView = UITableView.alloc.initWithFrame([[0,0],[320,460-44]], style: UITableViewStyleGrouped)
  end
  
  def viewDidLoad
    self.title = "Settings"
    tableView.allowsSelection = false
    @keyboardIsShown = false
  end

  def numberOfSectionsInTableView(tv)
    1
  end
  
  def tableView(tv, numberOfRowsInSection:section)
    EmailsStore.shared.emails.length + 1
  end
  
  def tableView(tv, titleForHeaderInSection:section)
    "Team Emails"
  end

  def tableView(tv, cellForRowAtIndexPath:indexPath)
    cell = UITableViewCell.alloc.initWithStyle(
                  UITableViewCellStyleSubtitle,
                  reuseIdentifier:nil)
    
    textField = EmailTextField.alloc.initWithFrame([[20,15],[view.frame.size.width - 20,44 - 15]])
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
    end
  end
  
  def textFieldDidBeginEditing(textField)
    @editing = true
  end
  
  def textFieldDidEndEditing(textField)
    textField.update_model
    EmailsStore.shared.save_email(textField.email)
    
    view.reloadData
    @editing = false
  end
  
  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
  end
  
end