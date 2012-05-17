class RunningLateController < UIViewController
  def viewDidLoad
    margin = 20
    self.title = "Running Late"
    label = UILabel.new
    label.frame = [[margin,20],[view.frame.size.width - margin * 2, 40]]
    label.text = "About how behind are you?"
    label.textAlignment = UITextAlignmentCenter
    label.textColor = UIColor.whiteColor
    label.backgroundColor = UIColor.clearColor
    view.addSubview(label)
    
    @arrayMinutes = ["5 mins","10 mins","15 mins","20 mins","30 mins","1 hour"]
    @selectedMinutes = @arrayMinutes[0]
    
    picker = UIPickerView.alloc.initWithFrame([[40,80],[view.frame.size.width - 40 * 2, 100]])
    picker.delegate = self
    picker.dataSource = self
    picker.showsSelectionIndicator = true
    view.addSubview(picker)
    
    @okButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @okButton.setTitle('Okay', forState:UIControlStateNormal)
    @okButton.frame = [[40,260],[view.frame.size.width - 40 * 2, 40]]
    @okButton.addTarget(self, action:'actionTapped:', forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@okButton)
    
    @emailSender = EmailSender.new
  end
  
  #-------------------Picker Methods-------------------#
  def numberOfComponentsInPickerView(thePickerView)
    return 1
  end
  
  def pickerView(pv, numberOfRowsInComponent:component)
    return @arrayMinutes.count
  end
  
  def pickerView(pv, titleForRow:row, forComponent:component) 
    return @arrayMinutes[row]
  end
  
  def pickerView(pv, didSelectRow:row, inComponent:component)
    #puts "Selected row: #{@arrayMinutes[row]}. Index of selected row: #{row}"
    @selectedMinutes = @arrayMinutes[row]
  end
  
  #-------------------okButton Methods-------------------#
  def actionTapped(sender)
    @emailSender.showEmail(self,"#{@selectedMinutes} Late Today",createEmailMessage(@selectedMinutes))
  end
  
  def createEmailMessage(time)
    "I am running about #{time} late today. Sorry!"
  end  
end