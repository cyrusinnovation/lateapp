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
  

  def emails_controller
    @emails_controller ||= EmailsController.alloc.init
  end
  
  def groups_controller
    @groups_controller ||= GroupsController.alloc.init
  end
 
end
