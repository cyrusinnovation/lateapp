class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    puts UIScreen.mainScreen.bounds.size.height
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav_controller
    # @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end

  def nav_controller
    @nav_controller ||= UINavigationController.alloc.initWithRootViewController(late_app_controller)
  end

  def late_app_controller
    @late_app_controller ||= LateAppController.alloc.init
  end

  def emails_controller
    @emails_controller ||= EmailsController.alloc.init
  end

  def groups_controller
    @groups_controller ||= GroupsController.alloc.init
  end

  def data_changed
    @late_app_controller.reload
  end

end
