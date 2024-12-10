import SwiftUI

struct ContentView: View {
    
    let buttonFontSize: CGFloat = 45
    let buttonMaxHeight: CGFloat = 120
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景画像を追加
                Image("Image") // アセットに入れた画像名
                    .resizable()
                    .scaledToFill() // 画面全体にフィットさせる
                    .edgesIgnoringSafeArea(.all) // 画面全体を覆う
                
                VStack(spacing: 20) {
                    Text("Push 学習 App")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black) // テキストの色を変更して背景に合わせる
                    
                    NavigationLink(destination: PostListView()) {
                        Text("投稿一覧")
                            .font(.system(size:buttonFontSize))
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: buttonMaxHeight)
                            .background(Color.blue.opacity(0.8)) // 少し透明にして背景と調和させる
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: SettingsView()) {
                        Text("設定")
                            .font(.system(size:buttonFontSize))
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity,maxHeight: buttonMaxHeight)
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: NotificationsView()) {
                        Text("お知らせ")
                            .font(.system(size:buttonFontSize))
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: buttonMaxHeight)
                            .background(Color.orange.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: ECommerceView()) {
                        Text("擬似EC")
                            .font(.system(size:buttonFontSize))
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: buttonMaxHeight)
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                }
                .padding()
            }
        }
        .onAppear{
            requestPushPermissions()
        }
    }
    
    func requestPushPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting push permissions: \(error.localizedDescription)")
            } else if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
}
