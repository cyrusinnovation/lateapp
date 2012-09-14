class LateAppController < UITableViewController
  LATE_ACTION = "Running Late"
  OUT_ACTION = "Out Sick"
  LATE_TITLE = "How Late?"
  OUT_TITLE = "Will You Check Email?"
  GROUP_TITLE = "Notify Which Group?"
  STATS_ACTION = "Statistics"
  SETTINGS_ACTION = "Settings"
  
  def loadView
    self.tableView = UITableView.alloc.initWithFrame([[0,44],[320,440]], style: UITableViewStyleGrouped)
  end  
  
  def viewDidLoad
    @actions = {NSIndexPath.indexPathForRow(0, inSection:0) => LATE_ACTION,
                NSIndexPath.indexPathForRow(1, inSection:0) => OUT_ACTION,
                NSIndexPath.indexPathForRow(0, inSection:1) => STATS_ACTION,
                NSIndexPath.indexPathForRow(1, inSection:1) => SETTINGS_ACTION
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
    2
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
    
    if @actions[indexPath] == LATE_ACTION || @actions[indexPath] == OUT_ACTION
      @current_action = @actions[indexPath]
      groups = EmailsStore.shared.active_groups
      if groups.length == 0
        @current_group_name = nil
        present_email_action_sheet
      elsif groups.length == 1
        @current_group_name = groups[0].name
        present_email_action_sheet
      else
        group_action_sheet = UIActionSheet.alloc.initWithTitle(GROUP_TITLE, delegate:self, cancelButtonTitle:nil, destructiveButtonTitle:nil, otherButtonTitles:nil)
        groups.each {|g|
          group_action_sheet.addButtonWithTitle(g.name)
        }
        group_action_sheet.addButtonWithTitle("Cancel")
        group_action_sheet.cancelButtonIndex = groups.length
        group_action_sheet.showInView(self.view)
      end
      
    elsif @actions[indexPath] == STATS_ACTION
      navigationController.pushViewController(StatisticsController.alloc.init, animated:true)
  
    elsif @actions[indexPath] == SETTINGS_ACTION
      groups_controller = UIApplication.sharedApplication.delegate.groups_controller
      navigationController.pushViewController(groups_controller, animated:true)

    end

    tv.deselectRowAtIndexPath(indexPath, animated:true)
  end
  
  def actionSheet(as, clickedButtonAtIndex:buttonIndex)
    unless buttonIndex == as.cancelButtonIndex
      
      if as.title == GROUP_TITLE
        @current_group_name = as.buttonTitleAtIndex(buttonIndex)
        present_email_action_sheet
      elsif as.title == LATE_TITLE
        selected_title = as.buttonTitleAtIndex(buttonIndex)
        time = selected_title.match(/(\d+)/)[0].to_i
        time = 60 if selected_title == "1 hour"
        @emailSender = EmailSender.alloc.initWithLate(selected_title, time, @current_group_name)
        @emailSender.showEmail(self)
      elsif as.title == OUT_TITLE
        selected_title = as.buttonTitleAtIndex(buttonIndex)
        @emailSender = EmailSender.alloc.initWithOut(selected_title, @current_group_name)
        @emailSender.showEmail(self)
      end  
    end
  end

  def present_email_action_sheet
    if @current_action == LATE_ACTION
      UIActionSheet.alloc.initWithTitle(LATE_TITLE, delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles:"5 minutes","15 minutes","30 minutes","1 hour",nil).showInView(self.view)
    elsif @current_action == OUT_ACTION
      UIActionSheet.alloc.initWithTitle(OUT_TITLE, delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles:"Will do","Maybe later","Probably not",nil).showInView(self.view)
    end
  end

  def willPresentActionSheet(as)
    as.subviews[0].setTextColor(UIColor.fromHexCode('44', '44', '44'))
    actionSheetBackgroundView = UIImageView.alloc.initWithFrame([[0, 0], as.bounds.size])
    actionSheetBackgroundView.setBackgroundColor(UIColor.fromHexCode('ab','df','f3'))
    as.insertSubview(actionSheetBackgroundView, atIndex:0)
  end
  

  def flash(msg)
    UIAlertView.alloc.initWithTitle("", message:msg, delegate:self, cancelButtonTitle:"OK", otherButtonTitles:nil).show
  end

  def reload
    tableView.reloadData
  end
end
