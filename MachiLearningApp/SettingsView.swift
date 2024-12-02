import SwiftUI

struct SettingsView: View {
    @State private var selectedTab: String = "MID設定" // 初期タブをMID設定に
    @AppStorage("mid") var mid: String = ""
    @AppStorage("appId") var appId: String = ""
    @AppStorage("token") var token: String = ""
    @AppStorage("url") var url: String = ""

    @AppStorage("memberId") var memberId: String = ""
    @AppStorage("nickname") var nickname: String = ""
    
    @State private var saveMessage: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("\(selectedTab)")
                    .font(.largeTitle)
                    .bold()

                if selectedTab == "MID設定" {
                    TextField("MID", text: $mid)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)

                    TextField("App ID", text: $appId)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)

                    TextField("Token", text: $token)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)

                    TextField("URL", text: $url)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                } else if selectedTab == "連絡先設定" {
                    TextField("会員ID", text: $memberId)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)

                    TextField("ニックネーム", text: $nickname)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }

                Button(action: {
                    saveSettings()
                    saveMessage = "設定の保存が完了しました。反映のためアプリを再起動してみてください。"
                }) {
                    Text("保存")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                if !saveMessage.isEmpty {
                    Text(saveMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("設定")
            .toolbar {
                Menu {
                    Button(action: {
                        selectedTab = "MID設定"
                        loadSettings()
                    }) {
                        Text("MID設定")
                    }

                    Button(action: {
                        selectedTab = "連絡先設定"
                        loadSettings()
                    }) {
                        Text("連絡先設定")
                    }
                } label: {
                    HStack {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                            .font(.system(size: 20))
                        
                        Text("設定切り替え")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .onAppear {
            loadSettings() // 画面が表示されたときに設定を読み込む
        }
    }
    
    // 設定を保存する関数
    func saveSettings() {
        UserDefaults.standard.set(mid, forKey: "mid")
        UserDefaults.standard.set(appId, forKey: "appId")
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(url, forKey: "url")
        UserDefaults.standard.set(memberId, forKey: "memberId")
        UserDefaults.standard.set(nickname, forKey: "nickname")
    }

    // 設定を読み込む関数
    func loadSettings() {
        mid = UserDefaults.standard.string(forKey: "mid") ?? ""
        appId = UserDefaults.standard.string(forKey: "appId") ?? ""
        token = UserDefaults.standard.string(forKey: "token") ?? ""
        url = UserDefaults.standard.string(forKey: "url") ?? ""
        memberId = UserDefaults.standard.string(forKey: "memberId") ?? ""
        nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
    }
}
