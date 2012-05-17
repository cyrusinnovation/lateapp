class LateAppController < UITableViewController
  
  def viewDidLoad
    @actions = ["Running Late", "Out Sick", "Settings"]
    self.title = "I'm Late!"
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
      late_action_sheet = UIActionSheet.alloc.initWithTitle("How late?", delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles:"5 minutes","15 minutes","30 minutes","1 hour",nil)
      late_action_sheet.showInView(self.view)
      
    elsif @actions[indexPath.row] == "Out Sick" 
      sick_action_sheet = UIActionSheet.alloc.initWithTitle("Will you check Email?", delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles:"Will do","Maybe later","Probably not",nil)
      sick_action_sheet.showInView(self.view)
      
    elsif @actions[indexPath.row] == "Settings" 
      settings_controller = UIApplication.sharedApplication.delegate.settings_controller
      navigationController.pushViewController(settings_controller, animated:true)
      
    end
  end
  
  def actionSheet(as, clickedButtonAtIndex:buttonIndex)
    unless buttonIndex == as.cancelButtonIndex
      @emailSender ||= EmailSender.new
      if as.title == "How late?"
        @emailSender.showEmail(self,"#{titlecase(as.buttonTitleAtIndex(buttonIndex))} Late Today", createLateEmailMessage(as.buttonTitleAtIndex(buttonIndex)))
      else
        @emailSender.showEmail(self,"Out Sick Today", createSickEmailMessage(as.buttonTitleAtIndex(buttonIndex)))
      end  
    end
  end

  def createLateEmailMessage(time)
    "I am running about #{time} late today. Sorry!"
  end
  
  def createSickEmailMessage(emailCheckingStatus)
    if emailCheckingStatus == "Will Do"
      "I am out sick. I will check my email periodically."
    elsif emailCheckingStatus == "Maybe Later"
      "I am out sick. I might check my email later depending on how I feel."
    else
      "I am out sick. I will probably not be able to check my email anytime soon, but I'll update you when I get a chance."
    end
  end
  
  def titlecase(str)
     non_capitalized = %w{of etc and by the for on is at to but nor or a via}
     str.gsub(/\b[a-z]+/){ |w| non_capitalized.include?(w) ? w : w.capitalize  }.sub(/^[a-z]/){|l| l.upcase }.sub(/\b[a-z][^\s]*?$/){|l| l.capitalize }
  end
  
end
