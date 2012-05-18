class SettingsController < UITableViewController
  def loadView
    self.tableView = UITableView.alloc.initWithFrame([[0,0],[320,460-44]], style: UITableViewStyleGrouped)
  end
  
  def viewDidLoad
    tableView.allowsSelection = false
    tableView.backgroundColor = UIColor.fromHexCode('5f', 'ff', '8f') # light green
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
  
  def tableView(tv, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    cell.subviews[2].textColor = UIColor.fromHexCode('44','44','44') # gray
  end

  def tableView(tv, cellForRowAtIndexPath:indexPath)
    cell = UITableViewCell.alloc.initWithStyle(
                  UITableViewCellStyleSubtitle,
                  reuseIdentifier:nil)
    
    textField = EmailTextField.alloc.initWithFrame([[20,10],[view.frame.size.width - 37,44 - 15]])
    textField.setTextColor(UIColor.fromHexCode('ff','44','44'))
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone
    textField.delegate = self
    if indexPath.row < EmailsStore.shared.emails.length
      textField.email = EmailsStore.shared.emails[indexPath.row]
    else
      textField.email = EmailsStore.shared.create_email()
    end
    cell.addSubview(textField)
    puts textField.contacts_button
    
    cell
  end
  
  def showPicker(sender)
    picker = ABPeoplePickerNavigationController.alloc.init
    picker.peoplePickerDelegate = self

    self.presentModalViewController(picker,animated:true)
  end  
  
  def peoplePickerNavigationControllerDidCancel(peoplePicker)
    self.dismissModalViewControllerAnimated(true)
  end


  def peoplePickerNavigationController(peoplePicker, shouldContinueAfterSelectingPerson:person)
    self.displayPerson(person)
    self.dismissModalViewControllerAnimated(true)

    return false
  end

  def peoplePickerNavigationController(peoplePicker, shouldContinueAfterSelectingPerson:person,
                                  property:property, identifier:identifier)
      return false
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