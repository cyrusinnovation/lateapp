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
    self.showEmailModalView
  end
  
  def showEmailModalView
     # Set up email controller
     picker = MFMailComposeViewController.alloc.init
     picker.mailComposeDelegate = self
     
     # Set Email properties
     recipients = []
     EmailsStore.shared.emails.each do |email|
      recipients << email.email
     end
     picker.setToRecipients(recipients)
     picker.setSubject("Out Sick")
     emailBody = "Hey, I am out sick today."
     picker.setMessageBody(emailBody,isHTML:true)
     
     # display
     picker.navigationBar.barStyle = UIBarStyleBlack
     self.presentModalViewController(picker, animated:true)
  end
  
  # Dismisses the email composition interface when users tap Cancel or Send. 
  # Proceeds to update the message field with the result of the operation.
  def mailComposeController(controller, didFinishWithResult:result, error:error)

    # # Notifies users about errors associated with the interface
    # case result
    #   when MFMailComposeResultCancelled
    #     break
    #   when MFMailComposeResultSaved
    #     break
    #   when MFMailComposeResultSent
    #     break
    #   when MFMailComposeResultFailed
    #     break
    #   else
    #     alert = UIAlertView.alloc.initWithTitle("Email", message:"Sending Failed - Unknown Error :-(",
    #                 delegate:self, cancelButtonTitle:"OK", otherButtonTitles: nil)
    #     alert.show
    #   break
    # end
    self.dismissModalViewControllerAnimated(true)
  end
  
end