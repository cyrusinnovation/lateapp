class GroupsController < UITableViewController
  def loadView
    self.tableView = UITableView.alloc.initWithFrame([[0,0],[320,460-44]], style: UITableViewStyleGrouped)
  end
  
  def viewDidLoad
    tableView.backgroundColor = UIColor.fromHexCode('5f', 'ff', '8f') # light green
    
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:"onClickAddItem:")
  end
  
  def numberOfSectionsInTableView(tv)
    1
  end
  
  def tableView(tv, numberOfRowsInSection:section)
    EmailsStore.shared.groups.length
  end
  
  def tableView(tv, titleForHeaderInSection:section)
    "Groups"
  end

  def tableView(tv, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    cell.textLabel.textColor = UIColor.fromHexCode('44','44','44') # gray
  end

  def tableView(tv, cellForRowAtIndexPath:indexPath)
    cell = UITableViewCell.alloc.initWithStyle(
                  UITableViewCellStyleSubtitle,
                  reuseIdentifier:nil)
    cell.textLabel.text = EmailsStore.shared.groups[indexPath.row].name
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell
  end
  
  def onClickAddItem(sender)
    alert = UIAlertView.alloc.initWithTitle("", message:"Enter name of group", delegate:self, cancelButtonTitle:"OK", otherButtonTitles:nil)
    alert.alertViewStyle = UIAlertViewStylePlainTextInput
    alert.show
  end
  
  def alertView(av, clickedButtonAtIndex:idx)
    t = av.textFieldAtIndex(0).text.strip
    if !(t == "")
      g = EmailsStore.shared.create_group
      g.name = t
      EmailsStore.shared.save_group(g)
      tableView.reloadData
    end
  end
  
  def standardCellHeight
    44
  end

  def tableView(tv, canEditRowAtIndexPath:indexPath)
    true
  end
  
  def tableView(tv, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tv, didSelectRowAtIndexPath:indexPath)
    emails_controller = UIApplication.sharedApplication.delegate.emails_controller
    emails_controller.current_group_name = EmailsStore.shared.groups[indexPath.row].name
    navigationController.pushViewController(emails_controller, animated:true)
    tv.deselectRowAtIndexPath(indexPath, animated:true)
  end
  
  def tableView(tv, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath )
    if (editingStyle == UITableViewCellEditingStyleDelete)
#      EmailsStore.shared.remove_group(EmailsStore.shared.groups[indexPath.row])
#      tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
    end
  end
  
end