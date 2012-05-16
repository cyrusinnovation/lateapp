class UIEmailTextField < UITextField
  def initWithFrame(frame)
    super(frame)
    self.placeholder = "Add email..."
    self.keyboardType = UIKeyboardTypeEmailAddress
    self.returnKeyType = UIReturnKeyDone
    self
  end
  
  def email
    @email
  end
  
  def email=(email)
    @email = email
    self.text = @email.email
  end
  
end