import SFMCSDK
import MarketingCloudSDK

// Set your AppDelegate class to adhere to the UIApplicationDelegate and UNUserNotificationCenterDelegate protocol.
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate, URLHandlingDelegate,InAppMessageEventDelegate{

    var window: UIWindow?
    // SDK: REQUIRED IMPLEMENTATION

    // The appID, accessToken and appEndpoint are required values for MobilePush SDK Module configuration and are obtained from your MobilePush app.
    // See https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/get-started/get-started-setupapps.html for more information.
//    #if DEBUG
    
    // UserDefaultsから取得する変数
     var appId: String =  "999999e9-8b69-4927-8d54-aa6bb6aa0096"
     var accessToken: String = "A"
     var appEndpoint: URL = URL(string: "https://")!
     var mid: String =  "9"
    
    // 指示；ここをUserDefaultから取得して設定する。ただしUserDefaultに値がない場合は "aaaaa"というダミー値を入れる。appendpointは https://example99988877776663344.co.jpとする


    // Define features of MobilePush your app will use.
    let inbox = true
    let location = false
    let analytics = true

    // SDK: REQUIRED IMPLEMENTATION
    func configureSDK() {
        // Enable logging for debugging early on. Debug level is not recommended for production apps, as significant data
        // about the MobilePush will be logged to the console.
        print("appId: \(appId)")
            print("accessToken: \(accessToken)")
            print("appEndpoint: \(appEndpoint)")
            print("mid: \(mid)")
        
        
        #if DEBUG
        SFMCSdk.setLogger(logLevel: .debug)
        #endif

        // Use the Mobile Push Config Builder to configure the Mobile Push Module. This gives you the maximum flexibility in SDK configuration.
        // The builder lets you configure the module parameters at runtime.
        let mobilePushConfiguration = PushConfigBuilder(appId: appId)
            .setAccessToken(accessToken)
            .setMarketingCloudServerUrl(appEndpoint)
            .setMid(mid)
            .setInboxEnabled(inbox)
            .setLocationEnabled(location)
            .setAnalyticsEnabled(analytics)
            .build()

        // Set the completion handler to take action when module initialization is completed. The result indicates if initialization was sucesfull or not.
        // Seting the completion handler is optional.
        let completionHandler: (OperationResult) -> () = { result in
            if result == .success {
                // module is fully configured and ready for use
                self.setupMobilePush()
            } else if result == .error {
                // module failed to initialize, check logs for more details
            } else if result == .cancelled {
                // module initialization was cancelled (for example due to re-confirguration triggered before init was completed)
            } else if result == .timeout {
                // module failed to initialize due to timeout, check logs for more details
            }
        }

        // Once you've created the mobile push configuration, intialize the SDK.
        SFMCSdk.initializeSdk(ConfigBuilder().setPush(config: mobilePushConfiguration, onCompletion: { result in
            switch result {
            case .success:
                self.setupMobilePush()
                print("MobilePush module initialized successfully! - 初期化に成功😊")
            case .error:
                print("Failed to initialize MobilePush module.失敗🚨")
            default:
                break
            }
        }).build())
        

        
        
    }

    /// Important method
    // MARK: - InAppMessageEventDelegate Implementation
    func sfmc_didShow(inAppMessage message: [AnyHashable : Any]) {
        print("In-App Message shown: \(message)")
        print("😊😊😊😊　Message表示！")
        // 必要に応じて追加処理
    }
    // koremo kakanaito dame
    func sfmc_shouldShow(inAppMessage message: [AnyHashable: Any]) -> Bool {
        // ロジックを記述（必要なら条件を入れる）
        // true を返すとメッセージが表示される
        print("Deciding whether to show message: \(message)")
        return true
    }
    

    func sfmc_didClose(inAppMessage message: [AnyHashable : Any]) {
        print("In-App Message closed: \(message)")
        print("👋👋👋　バイバイ！")
    }

    /// Enable pushg
    func setupMobilePush() {
        SFMCSdk.requestPushSdk { mp in
            ///これをするためにはURLHandlingDelegateを宣言しなきゃ行けないが
            ///そのためには sfmc_handleURLが必須になる
            mp.setURLHandlingDelegate(self)
            // Set the event delegate for In-App Messaging
            mp.setEventDelegate(self)
            
        }
 

        DispatchQueue.main.async {
            UNUserNotificationCenter.current().delegate = self

            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if error == nil && granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
    }
    
    // UserDefaultsから設定を読み込む

    // UserDefaultsから設定を読み込む
    private func loadSettingsFromUserDefaults() {
        let defaults = UserDefaults.standard

        // 初期値の辞書
        let defaultValues: [String: Any] = [
            "appId": "999999e9-8b69-4927-8d54-aa6bb6aa0096",
            "token": "aaaaa",
            "mid": "11111",
            "url": "https://"
        ]

        // 初期値をUserDefaultsに設定しつつ読み込む
        appId = defaults.string(forKey: "appId") ?? defaultValues["appId"] as! String
        defaults.set(appId, forKey: "appId") // 初回時にデフォルト値を保存

        accessToken = defaults.string(forKey: "token") ?? defaultValues["token"] as! String
        defaults.set(accessToken, forKey: "token") // 初回時にデフォルト値を保存

        mid = defaults.string(forKey: "mid") ?? defaultValues["mid"] as! String
        defaults.set(mid, forKey: "mid") // 初回時にデフォルト値を保存

        // URLの処理
        if let endpointString = defaults.string(forKey: "url"),
           let endpointURL = URL(string: endpointString) {
            appEndpoint = endpointURL
        } else {
            appEndpoint = URL(string: defaultValues["url"] as! String)!
            defaults.set(appEndpoint.absoluteString, forKey: "url") // 初回時にデフォルト値を保存
        }

        // 設定内容のログ出力
        print("Loaded Settings:")
        print("appId: \(appId)")
        print("accessToken: \(accessToken)")
        print("mid: \(mid)")
        print("appEndpoint: \(appEndpoint)")
    }
    
    
    
    // EXAMPLE IMPLEMENTATIONS
    // これはそのままIOSに処理させるだけのサンプル
    func sfmc_handleURL(_ url: URL, type: String) {
        if UIApplication.shared.canOpenURL(url) == true {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    if success {
                        print("url \(url) opened successfully")
                    } else {
                        print("url \(url) could not be opened")
                    }
                })
            } else {
                if UIApplication.shared.openURL(url) == true {
                    print("url \(url) opened successfully")
                } else {
                    print("url \(url) could not be opened")
                }
            }
        }
    }
    

    // SDK: REQUIRED IMPLEMENTATION
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadSettingsFromUserDefaults()
        self.configureSDK()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SFMCSdk.requestPushSdk { mp in
            mp.setDeviceToken(deviceToken)
        }
    }

    
    // MobilePush SDK: REQUIRED IMPLEMENTATION
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        SFMCSdk.requestPushSdk { mp in
            mp.setNotificationUserInfo(userInfo)
            
        }
        completionHandler(.newData)
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        SFMCSdk.requestPushSdk { mp in
            mp.setNotificationRequest(response.notification.request)
        }
        completionHandler()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .sound, .badge])
    }
    
    

//    // SDK: OPTIONAL IMPLEMENTATION (if using Data Protection)
//    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
//        if (SFMCSdk.mp.getStatus() != .operational) {
//            self.configureSFMCSdk()
//        }
//    }
}
