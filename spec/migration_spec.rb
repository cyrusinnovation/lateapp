describe 'Data Model Stuff' do
  it 'can migrate' do
    EmailsStore.shared.should.not.nil?
    EmailsStore.shared.create_email.should.respond_to?(:group)
  end
end