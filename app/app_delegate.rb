class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(LateAppController.alloc.initWithStyle(UITableViewStylePlain))
    @window.rootViewController.wantsFullScreenLayout = true
    @window.backgroundColor = UIColor.alloc.initWithRed(0.4, green: 0.99, blue: 0.5, alpha: 0.7)
    @window.makeKeyAndVisible
    true
  end
  
  def running_late_controller
    @running_late_controller ||= RunningLateController.alloc.init
  end
  
  def out_sick_controller
    @out_sick_controller ||= OutSickController.alloc.init
  end
  
  def settings_controller
    @settings_controller ||= SettingsController.alloc.init
  end
end
