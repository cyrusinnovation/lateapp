describe "Email Validator" do
  before do
    @validator = EmailValidator.new
  end

  it "works with our email addresses" do
    @validator.validate('jason@jasonreid.com').should == true
    @validator.validate('bbrown@cyrusinnovation.com').should == true
  end
  
  it "doesn't validate empty email addresses" do
    @validator.validate('').should == false
  end
  
  it "doesn't validate bad email addresses" do
    @validator.validate('abcdafsafsd').should == false
    @validator.validate('@').should == false
    @validator.validate('@.com').should == false
    @validator.validate('adsfasfsdf@').should == false
    @validator.validate('jason\n@jasonreid.com').should == false
    @validator.validate('jason@jason@reid.com').should == false
    @validator.validate('jason@jason').should == false
    @validator.validate('jason@jasonreid.asdfasfdafsd').should == false
  end
end
