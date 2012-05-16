class SettingsController < UIViewController
  def loadView
    super
    @emails = [MemoryEmail.new("abc@cyrus.com", 0), MemoryEmail.new("def@cyrus.com", 1)]
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
    
    @emailsTable = UITableView.alloc.initWithFrame([[20, 70], [view.frame.size.width - 20 * 2, (@emails.length + 1) * standardCellHeight]], 
      style:UITableViewStylePlain)
    @emailsTable.layer.cornerRadius = 10
    @emailsTable.delegate = @emailsTable.dataSource = self
    @ui_view.addSubview(@emailsTable)
    
    view.addSubview(@scroll_view)
    recalculate_table_height
  end
  
  def tableView(tv, numberOfRowsInSection:section)
    @emails.length + 1
  end

  def tableView(tv, cellForRowAtIndexPath:indexPath)
    
    cell = UITableViewCell.alloc.initWithStyle(
                  UITableViewCellStyleSubtitle,
                  reuseIdentifier:nil)
    
    textField = UIEmailTextField.alloc.initWithFrame([[0,0],[200,44]])
    textField.delegate = self
    if indexPath.row < @emails.length
      textField.email = @emails[indexPath.row]
    else
      textField.email = MemoryEmail.new('', @emails.length)
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
    #puts("editingStyle")
    UITableViewCellEditingStyleDelete
  end
  
  def tableView(tv, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath )
    if (editingStyle == UITableViewCellEditingStyleDelete)
      @emails.delete_at(indexPath.row)
      tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
      recalculate_table_height
    end
  end
  
  def textFieldDidBeginEditing(textField)
    if textField.email.index == @emails.length
      @addingNew = true
    else
      @addingNew = false
    end
  end
  
  def textFieldDidEndEditing(textField)
    #TODO refactor this terrible code
    textField.email.email = textField.text

    if @addingNew and textField.text != ""
      @emails << textField.email
    end
    
    @emailsTable.reloadData
    recalculate_table_height
  end
  
  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
  end
  
  def recalculate_table_height
    fr = @emailsTable.frame
    new_height = (@emails.length + 1) * standardCellHeight
    @emailsTable.frame = [fr[0], [fr.size.width, new_height]]
    bottom = @emailsTable.frame.origin.y + @emailsTable.frame.size.height
    
    @ui_view.frame = [@ui_view.frame[0], 
                      [@ui_view.frame.size.width, 
                       [view.frame.size.height, bottom + 20].max]]
    
    @scroll_view.contentSize = @ui_view.frame.size
    puts @scroll_view.contentSize.height
    puts @scroll_view.frame.size.height
  end
  
end