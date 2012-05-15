class LateAppController < UITableViewController
  
  def viewDidLoad
    @actions = ["Running Late", "Out Sick", "Settings"]
    self.title = "JobSnooze"
  end
  
  def tableView(tv, numberOfRowsInSection:section)
    3
  end

  def tableView(tv, cellForRowAtIndexPath:indexPath)
    cell = UITableViewCell.alloc.initWithStyle(
                  UITableViewCellStyleSubtitle,
                  reuseIdentifier:nil)
    cell.textLabel.text = @actions[indexPath.row]
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell
  end
  
  def tableView(tv, didSelectRowAtIndexPath:indexPath)
    #puts @actions[indexPath.row]
    if @actions[indexPath.row] == "Running Late" 
      late_controller = UIApplication.sharedApplication.delegate.running_late_controller
      navigationController.pushViewController(late_controller, animated:true)
    elsif @actions[indexPath.row] == "Out Sick" 
      sick_controller = UIApplication.sharedApplication.delegate.out_sick_controller
      navigationController.pushViewController(sick_controller, animated:true)
    elsif @actions[indexPath.row] == "Settings" 
      settings_controller = UIApplication.sharedApplication.delegate.settings_controller
      navigationController.pushViewController(settings_controller, animated:true)
    end
  end
end