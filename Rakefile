$:.unshift("/Library/RubyMotion/lib")
require 'bundler'
require 'motion/project/template/ios'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = "I'm Late!"
  app.icons = ["Icon.png","Icon@2x.png",
               "Icon-72.png","Icon-72@2x.png",
               "Icon-Small.png","Icon-Small@2x.png",
               "Icon-Small-50.png","Icon-Small-50@2x.png"]
  app.prerendered_icon = true
  app.frameworks += ['CoreData', 'MessageUI']

  app.release do
    app.codesign_certificate = 'iPhone Distribution: Cyrus Innovation'
    app.identifier = 'com.cyrusinnovation.imlate'
    app.provisioning_profile = '/Users/cyrus/Library/MobileDevice/Provisioning Profiles/D22F0DDF-2DFA-4C7C-B8E2-82494EB1C010.mobileprovision'
  end
end
