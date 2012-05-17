class SettingsController < UIViewController
  def loadView
    super
  end
  
  def viewDidLoad
    @scroll_view = UIScrollView.alloc.initWithFrame([[0, 0],[view.frame.size.width, view.frame.size.height - item_height]])
    @ui_view = UIView.alloc.initWithFrame([[0, 0],[view.frame.size.width, view.frame.size.height - item_height]])
    @scroll_view.addSubview(@ui_view)
    
    self.title = "Settings"
    
    label = UILabel.new
    label.frame = [[margin, margin],[content_width, item_height]]
    label.text = "Team Emails"
    label.textAlignment = UITextAlignmentCenter
    label.textColor = UIColor.whiteColor
    label.backgroundColor = UIColor.clearColor
    @ui_view.addSubview(label)
    
    @emailsTable = UITableView.alloc.initWithFrame([[20, 70], [content_width, (EmailsStore.shared.emails.length + 1) * standardCellHeight]], 
      style:UITableViewStylePlain)
    @emailsTable.allowsSelection = false
    @emailsTable.layer.cornerRadius = 10
    @emailsTable.delegate = @emailsTable.dataSource = self
    @ui_view.addSubview(@emailsTable)
    
    view.addSubview(@scroll_view)
    recalculate_table_height

    NSNotificationCenter.defaultCenter.addObserver(self, selector:'keyboardWillShow:', name:UIKeyboardWillShowNotification, object:self.view.window)
    NSNotificationCenter.defaultCenter.addObserver(self, selector:'keyboardWillHide:', name:UIKeyboardWillHideNotification, object:self.view.window)
    
    @keyboardIsShown = false
  end

  def viewDidUnload 
    NSNotificationCenter.defaultCenter.removeObserver(self, name:UIKeyboardWillShowNotification, object:nil)
    NSNotificationCenter.defaultCenter.removeObserver(self, name:UIKeyboardWillHideNotification, object:nil)
  end

  def keyboardWillHide(n)
    userInfo = n.userInfo
    keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey).CGRectValue.size

    view_frame = @scroll_view.frame
    UIView.beginAnimations(nil, context:nil)
    UIView.setAnimationBeginsFromCurrentState(true)
    UIView.setAnimationDuration(0.3)
    view_frame.size.height += keyboardSize.height
    @scroll_view.setFrame([@scroll_view.frame.origin,[@scroll_view.frame.size.width,view_frame.size.height]])
    UIView.commitAnimations
    @keyboardIsShown = false
  end
  
  def keyboardWillShow(n)
    userInfo = n.userInfo
    keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey).CGRectValue.size
    
    view_frame = @scroll_view.frame
    newHeight = view_frame.size.height - keyboardSize.height
    UIView.beginAnimations(nil, context:nil)
    UIView.setAnimationBeginsFromCurrentState(true)
    UIView.setAnimationDuration(0.3)
    view_frame.size.height -= keyboardSize.height unless @keyboardIsShown
    @scroll_view.setFrame([@scroll_view.frame.origin,[@scroll_view.frame.size.width,view_frame.size.height]])
    @scroll_view.contentOffset = [0, @activeOffset - (newHeight / 2)]
    UIView.commitAnimations
    @keyboardIsShown = true
  end

  
  def item_height
    44
  end
  def margin
    20
  end
  def content_width
    view.frame.size.width - (margin * 2)
  end
  
  def tableView(tv, numberOfRowsInSection:section)
    EmailsStore.shared.emails.length + 1
  end

  def tableView(tv, cellForRowAtIndexPath:indexPath)
    
    cell = UITableViewCell.alloc.initWithStyle(
                  UITableViewCellStyleSubtitle,
                  reuseIdentifier:nil)
    
    textField = UIEmailTextField.alloc.initWithFrame([[10,15],[content_width - 10,item_height - 15]])
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
    #textField + cell + table
    @activeOffset = textField.frame.origin.y + textField.superview.frame.origin.y + textField.superview.superview.frame.origin.y
  end
  
  def textFieldDidEndEditing(textField)
    #TODO refactor this terrible code
    textField.update_model
    EmailsStore.shared.save_email(textField.email)
    
    @emailsTable.reloadData
    recalculate_table_height
    @editing = false
    @activeOffset = 0
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