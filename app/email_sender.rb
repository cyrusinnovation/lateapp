class EmailSender
  
  def showEmail(controller, subject, message)
     # Set up email controller
     picker = MFMailComposeViewController.alloc.init
     picker.mailComposeDelegate = self
   
     # Set Email properties
     recipients = []
     EmailsStore.shared.emails.each do |email|
       recipients << email.email
     end
     picker.setToRecipients(recipients)
     puts "set to recips done"
     picker.setSubject(subject)
     picker.setMessageBody(message,isHTML:true)
   
     # display
     picker.navigationBar.barStyle = UIBarStyleBlack
     controller.presentModalViewController(picker, animated:true)
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
    controller.dismissModalViewControllerAnimated(true)
  end
end