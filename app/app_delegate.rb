class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = DemoController.alloc.init
    @window.makeKeyAndVisible
    @window.backgroundColor = "#ffffff".uicolor

    true
  end
end
