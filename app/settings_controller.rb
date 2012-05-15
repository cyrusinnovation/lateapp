class SettingsController < UIViewController
  def viewDidLoad

    self.title = "Settings"
    
    label = UILabel.new
    label.frame = [[20,20],[view.frame.size.width - 20 * 2, 40]]
    label.text = "Team Emails"
    label.textAlignment = UITextAlignmentCenter
    label.textColor = UIColor.whiteColor
    label.backgroundColor = UIColor.clearColor
    view.addSubview(label)
    
  end
  
  
end