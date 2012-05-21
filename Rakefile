$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = "I'm Late!"
  app.icons = ["icon57.png","icon114.png"]
  app.frameworks += ['CoreData', 'MessageUI', 'AddressBook']

  app.codesign_certificate = 'iPhone Distribution: Cyrus Innovation'
  app.identifier = 'com.cyrusinnovation.imlate'
  app.provisioning_profile = '/Users/cyrus/Library/MobileDevice/Provisioning Profiles/D22F0DDF-2DFA-4C7C-B8E2-82494EB1C010.mobileprovision'

  app.pods do
    dependency 'ABContactHelper'
  end
end
