class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav_controller
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
  
  def nav_controller
    @nav_controller ||= UINavigationController.alloc.initWithRootViewController(LateAppController.alloc.initWithStyle(UITableViewStylePlain))
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
