class EmailTextField < UITextField
  def initWithFrame(frame)
    super(frame)
    self.placeholder = "Add email..."
    self.keyboardType = UIKeyboardTypeEmailAddress
    self.returnKeyType = UIReturnKeyDone
    self.rightView = UIButton.buttonWithType(UIButtonTypeContactAdd)
    self.rightViewMode = UITextFieldViewModeWhileEditing
    @contacts_button = self.rightView
    

    self
  end
  
  def email
    @email
  end
  
  def email=(email)
    @email = email
    self.text = @email.email
    update_model
  end
  
  def contacts_button
    @contacts_button
  end
  
  def update_model
    @email.email = self.text
    display_validity
  end
  
  def display_validity
    if EmailValidator.new.validate(@email.email)
      self.textColor = UIColor.blackColor
    else
      self.textColor = UIColor.redColor
    end
  end
end