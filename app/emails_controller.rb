class EmailsController < UITableViewController
  attr_accessor :current_group_name

  def loadView
    table_height = UIScreen.mainScreen.bounds.size.height - 44
    self.tableView = UITableView.alloc.initWithFrame([[0,0],[320,table_height]], style: UITableViewStyleGrouped)
  end

  def viewDidLoad
    tableView.allowsSelection = false
    tableView.backgroundColor = UIColor.fromHexCode('5f', 'ff', '8f') # light green
  end

  def viewWillAppear(animated)
    tableView.reloadData
  end

  def numberOfSectionsInTableView(tv)
    1
  end

  def tableView(tv, numberOfRowsInSection:section)

    current_emails.length + 1
  end

  def tableView(tv, titleForHeaderInSection:section)
    "#{current_group_name} Emails"
  end

  def tableView(tv, cellForRowAtIndexPath:indexPath)
    cell = UITableViewCell.alloc.initWithStyle(
                  UITableViewCellStyleSubtitle,
                  reuseIdentifier:nil)

    textField = EmailTextField.alloc.initWithFrame([[20,10],[view.frame.size.width - 37,44 - 15]])
    textField.setTextColor(UIColor.fromHexCode('ff','44','44'))
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone
    textField.delegate = self
    if indexPath.row < current_emails.length
      textField.email = current_emails[indexPath.row]
    else
      textField.email = EmailsStore.shared.create_email()
      textField.email.group = current_group_name
    end
    cell.addSubview(textField)


    textField.contacts_button.addTarget(self, action:"showPicker:", forControlEvents:UIControlEventTouchUpInside)

    cell
  end

  def showPicker(sender)

    picker = ABPeoplePickerNavigationController.alloc.init
    picker.displayedProperties = [KABPersonEmailProperty]
    picker.peoplePickerDelegate = self



    self.presentModalViewController(picker,animated:true)
  end

  def peoplePickerNavigationControllerDidCancel(peoplePicker)
    self.dismissModalViewControllerAnimated(true)
  end


  def peoplePickerNavigationController(peoplePicker, shouldContinueAfterSelectingPerson:person)
    return true
  end

  def peoplePickerNavigationController(peoplePicker, shouldContinueAfterSelectingPerson:person,
                                  property:property, identifier:identifier)
      selected_value = ABRecordCopyValue(person, property)
      index = ABMultiValueGetIndexForIdentifier(selected_value, identifier)
      selected_email_address = ABMultiValueCopyValueAtIndex(selected_value, index)

      email = EmailsStore.shared.create_email()
      email.email = selected_email_address
      EmailsStore.shared.save_email(email)

      peoplePicker.dismissViewControllerAnimated(true, completion:lambda do
        indexPath = NSIndexPath.indexPathForRow(EmailsStore.shared.emails.length-1, inSection:0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationTop)
      end)
      return false
  end

  def standardCellHeight
    44
  end

  def tableView(tv, canEditRowAtIndexPath:indexPath)
    true
  end

  def tableView(tv, editingStyleForRowAtIndexPath:indexPath)
    if indexPath.row < current_emails.length and !@editing
      UITableViewCellEditingStyleDelete
    else
      UITableViewCellEditingStyleNone
    end
  end

  def tableView(tv, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath )
    if (editingStyle == UITableViewCellEditingStyleDelete)
      EmailsStore.shared.remove(current_emails[indexPath.row])
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

  private

  def current_emails
    EmailsStore.shared.emails_in_group(current_group_name)
  end

end