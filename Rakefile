$:.unshift("/Library/RubyMotion/lib")
require 'bundler'
require 'motion/project/template/ios'
Bundler.require
require 'sugarcube-repl'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = "I'm Late!"
  app.icons = ["Icon.png","Icon@2x.png",
               "Icon-72.png","Icon-72@2x.png",
               "Icon-Small.png","Icon-Small@2x.png",
               "Icon-Small-50.png","Icon-Small-50@2x.png"]
  app.prerendered_icon = true
  app.frameworks += ['CoreData', 'MessageUI']

  app.development do
    app.codesign_certificate = 'iPhone Distribution: Cyrus Innovation (Z7HUA7E8W9)'
    app.identifier = 'com.cyrusinnovation.imlate'
    app.provisioning_profile = './provisioning/Im_Late_Dev_profile.mobileprovision'
    app.entitlements['get-task-allow'] = false
  end

  app.release do
    app.codesign_certificate = 'iPhone Distribution: Cyrus Innovation (Z7HUA7E8W9)'
    app.identifier = 'com.cyrusinnovation.imlate'
    app.provisioning_profile = './provisioning/I_am_running_late_distribution_profile.mobileprovision'
    app.entitlements['get-task-allow'] = false
  end
end
