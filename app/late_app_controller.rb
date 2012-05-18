class LateAppController < UITableViewController
  
  def loadView
    self.tableView = UITableView.alloc.initWithFrame([[0,44],[320,440]], style: UITableViewStyleGrouped)
  end  
  
  def viewDidLoad
    @actions = {NSIndexPath.indexPathForRow(0, inSection:0) => "Running Late",
                NSIndexPath.indexPathForRow(1, inSection:0) => "Out Sick",
                NSIndexPath.indexPathForRow(0, inSection:1) => "Settings"}
    tableView.backgroundColor = UIColor.fromHexCode('5f', 'ff', '8f') # light green
    tableView.sectionHeaderHeight = 40
    tableView.sectionFooterHeight = 100
    tableView.rowHeight = 64
    navigationController.navigationBar.setBackgroundImage(UIImage.imageNamed("banner.png"), forBarMetrics:UIBarMetricsDefault)
  end
  
  def tableView(tv, numberOfRowsInSection:section)
    if section == 0
      2
    else
      1
    end
  end

  def numberOfSectionsInTableView(tv)
    2
  end

  def tableView(tv, cellForRowAtIndexPath:indexPath)
    cell = UITableViewCell.alloc.initWithStyle(
                  UITableViewCellStyleSubtitle,
                  reuseIdentifier:nil)
    cell.textLabel.text = @actions[indexPath]
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell
  end
  
  def tableView(tv, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    cell.setBackgroundColor(UIColor.whiteColor)
    cell.textLabel.textColor = UIColor.fromHexCode('44','44','44') # gray
  end
  
  def tableView(tv, didSelectRowAtIndexPath:indexPath)
    
    if @actions[indexPath] == "Running Late"
      late_action_sheet = UIActionSheet.alloc.initWithTitle("How late?", delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles:"5 minutes","15 minutes","30 minutes","1 hour",nil)
      late_action_sheet.showInView(self.view)
      
    elsif @actions[indexPath] == "Out Sick" 
      sick_action_sheet = UIActionSheet.alloc.initWithTitle("Will you check Email?", delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles:"Will do","Maybe later","Probably not",nil)
      sick_action_sheet.showInView(self.view)
      
    elsif @actions[indexPath] == "Settings" 
      settings_controller = UIApplication.sharedApplication.delegate.settings_controller
      navigationController.pushViewController(settings_controller, animated:true)
    end

    tv.deselectRowAtIndexPath(indexPath, animated:true)
  end
  
  def willPresentActionSheet(as)
    as.subviews[0].setTextColor(UIColor.fromHexCode('44', '44', '44'))
    actionSheetBackgroundView = UIImageView.alloc.initWithFrame([[0, 0], as.bounds.size])
    actionSheetBackgroundView.setBackgroundColor(UIColor.fromHexCode('ab','df','f3'))
    as.insertSubview(actionSheetBackgroundView, atIndex:0)
  end
  
  def actionSheet(as, clickedButtonAtIndex:buttonIndex)
    unless buttonIndex == as.cancelButtonIndex
      @emailSender ||= EmailSender.new
      if as.title == "How late?"
        @emailSender.showEmail(self,"#{@emailSender.titlecase(as.buttonTitleAtIndex(buttonIndex))} Late Today", @emailSender.createLateEmailMessage(as.buttonTitleAtIndex(buttonIndex)))
      else
        @emailSender.showEmail(self,"Out Sick Today", @emailSender.createSickEmailMessage(as.buttonTitleAtIndex(buttonIndex)))
      end  
    end
  end

end
