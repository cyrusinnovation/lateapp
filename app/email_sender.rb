class EmailSender
  
  def initWithLate(time)
    @subject = "#{self.titlecase(time)} Late Today"
    @message = createLateEmailMessage(time)
    self
  end
  
  def initWithSick(emailCheckingStatus)
    @subject = "Out Sick Today"
    @message = createSickEmailMessage(emailCheckingStatus)
    self
  end
  
  def showEmail(controller)
     # Set up email controller
     composer = MFMailComposeViewController.alloc.init
     composer.mailComposeDelegate = self
   
     # Set Email properties
     recipients = []
     EmailsStore.shared.emails.each do |email|
       recipients << email.email
     end
     composer.setToRecipients(recipients)
     composer.setSubject(@subject)
     composer.setMessageBody(@message,isHTML:true)
   
     # Display
     composer.navigationBar.barStyle = UIBarStyleBlack
     controller.presentModalViewController(picker, animated:true)
  end

  # Dismisses the email composition interface when users tap Cancel or Send. 
  # Proceeds to update the message field with the result of the operation.
  def mailComposeController(controller, didFinishWithResult:result, error:error)
    puts "finished with email interface Result: #{result}; Error: #{error}."
    controller.dismissModalViewControllerAnimated(true)
  end
  
  private 
  
  def createLateEmailMessage(time)
    "I am running about #{time} late today. Sorry!"
  end
  
  def createSickEmailMessage(emailCheckingStatus)
    if emailCheckingStatus == "Will do"
      "I am out sick. I will check my email periodically."
    elsif emailCheckingStatus == "Maybe later"
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