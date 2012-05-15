class OutSickController < UIViewController
  def viewDidLoad

    self.title = "Out Sick"
    label = UILabel.new
    label.frame = [[20,20],[view.frame.size.width - 20 * 2, 40]]
    label.text = "Will you be checking email?"
    label.textAlignment = UITextAlignmentCenter
    label.textColor = UIColor.whiteColor
    label.backgroundColor = UIColor.clearColor
    view.addSubview(label)
    
    @yesButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @yesButton.setTitle('Will Do', forState:UIControlStateNormal)
    @yesButton.frame = [[40,80],[view.frame.size.width - 40 * 2, 40]]
    @yesButton.addTarget(self, action:'buttonPressed:', forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@yesButton)
    
    @maybeButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @maybeButton.setTitle('Maybe Later', forState:UIControlStateNormal)
    @maybeButton.frame = [[40,130],[view.frame.size.width - 40 * 2, 40]]
    @maybeButton.addTarget(self, action:'buttonPressed:', forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@maybeButton)
    
    @noButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @noButton.setTitle('Probably Not', forState:UIControlStateNormal)
    @noButton.frame = [[40,180],[view.frame.size.width - 40 * 2, 40]]
    @noButton.addTarget(self, action:'buttonPressed:', forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@noButton)
  end
  
  def buttonPressed(sender)
    
  end
  
end