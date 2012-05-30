class LateAppController < UITableViewController
  
  def loadView
    self.tableView = UITableView.alloc.initWithFrame([[0,44],[320,440]], style: UITableViewStyleGrouped)
  end  
  
  def viewDidLoad
    @actions = {NSIndexPath.indexPathForRow(0, inSection:0) => "Running Late",
                NSIndexPath.indexPathForRow(1, inSection:0) => "Out Sick",
                NSIndexPath.indexPathForRow(0, inSection:1) => "Statistics",
                NSIndexPath.indexPathForRow(1, inSection:1) => "Settings"
                }
    tableView.backgroundColor = UIColor.fromHexCode('5f', 'ff', '8f') # light green
    tableView.sectionHeaderHeight = 40
    tableView.rowHeight = 64
    navigationController.navigationBar.setBackgroundImage(UIImage.imageNamed("banner.png"), forBarMetrics:UIBarMetricsDefault)
  end
  
  def tableView(tv, heightForFooterInSection:section)
    if section == 0
      65
    else
      0
    end
  end  
  
  def tableView(tv, numberOfRowsInSection:section)
    if section == 0
      2
    else
      2
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
    cell.textLabel.textColor = UIColor.fromHexCode('44','44','44') # gray
  end
  
  def tableView(tv, didSelectRowAtIndexPath:indexPath)
    
    if @actions[indexPath] == "Running Late"
      late_action_sheet = UIActionSheet.alloc.initWithTitle("How late?", delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles:"5 minutes","15 minutes","30 minutes","1 hour",nil)
      late_action_sheet.showInView(self.view)
      
    elsif @actions[indexPath] == "Out Sick" 
      out_action_sheet = UIActionSheet.alloc.initWithTitle("Will you check Email?", delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles:"Will do","Maybe later","Probably not",nil)
      out_action_sheet.showInView(self.view)
      
    elsif @actions[indexPath] == "Statistics" 
      navigationController.pushViewController(StatisticsController.alloc.init, animated:true)
  
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
      
      if as.title == "How late?"
        selected_title = as.buttonTitleAtIndex(buttonIndex)
        time = selected_title.match(/(\d+)/)[0].to_i
        time = 60 if selected_title == "1 hour"
        EmailSender.alloc.initWithLate(selected_title, time).showEmail(self)
      else
        selected_title = as.buttonTitleAtIndex(buttonIndex)
        EmailSender.alloc.initWithOut(selected_title).showEmail(self)
      end  
    end
  end

end
