class EmailSender
  
  def initWithLate(title, time)
    @subject = "#{titlecase(title)} Late Today"
    @message = createLateEmailMessage(title) + "<br><br>" + trademark
    @statistic = StatisticsStore.shared.create_late(time)
    @token = :late
    self
  end
  
  def initWithOut(emailCheckingStatus)
    @subject = "Out Sick Today"
    @message = createOutEmailMessage(emailCheckingStatus) + "<br><br>" + trademark
    @statistic = StatisticsStore.shared.create_out()
    @token = :out
    self
  end
  
  def showEmail(controller)
    @controller = controller
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
    composer.setMessageBody(@message, isHTML:true)
    
    # Display
    composer.navigationBar.barStyle = UIBarStyleBlack
    @controller.presentModalViewController(composer, animated:true)
  end

  def humor
    {
      :late => "Travel safely.",
      :out => "Feel better!"
    }
  end

  def mailComposeController(controller, didFinishWithResult:result, error:error)
    if (result == MFMailComposeResultSaved || result == MFMailComposeResultSent)
      StatisticsStore.shared.save_entity(@statistic)
    end
    controller.dismissViewControllerAnimated(true, completion:lambda do
      flash_message = {
        MFMailComposeResultSaved => "Saved message to drafts folder.",
        MFMailComposeResultSent => "Message sent! #{humor[@token]}",
        MFMailComposeResultFailed => "Something went wrong. Maybe call someone instead."
      }
      
      @controller.flash(flash_message[result]) unless flash_message[result].nil?
    end)
  end
  
  private 
  
  def createLateEmailMessage(time)
    "I am running about #{time} late today. Sorry!"
  end
  
  def trademark
    "<em>Quickly composed by <a href=\"http://itunes.apple.com/us/app/im-late!/id528671018?ls=1&mt=8\">I'm Late!</a></em>" 
  end
  
  def createOutEmailMessage(emailCheckingStatus)
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