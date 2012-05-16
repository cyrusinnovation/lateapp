class EmailValidator
  def validate(email)
    return false if email.nil?
    
    email.empty? or /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.match(email).nil? == false
  end
end