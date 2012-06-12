class GroupTextField < UITextField
  def initWithFrame(frame)
    super(frame)
    self.placeholder = "Add group..."
    self.keyboardType = UIKeyboardTypeDefault
    self.returnKeyType = UIReturnKeyDone
    self.rightView = UIButton.buttonWithType(UIButtonTypeContactAdd)
    self.rightViewMode = UITextFieldViewModeWhileEditing
    @emails_button = self.rightView

    self
  end
  
  def group
    @group
  end
  
  def group=(group)
    @group = group
    self.text = @group.name
    update_model
  end
  
  def emails_button
    @emails_button
  end
  
  def update_model
    @group.name = self.text
  end
end