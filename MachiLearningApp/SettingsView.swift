import SwiftUI
import SFMCSDK
import MarketingCloudSDK

struct SettingsView: View {
    @State private var selectedTab: String = "Push設定"
    @AppStorage("mid") var mid: String = ""
    @AppStorage("appId") var appId: String = ""
    @AppStorage("token") var token: String = ""
    @AppStorage("url") var url: String = ""
    @AppStorage("memberId") var memberId: String = ""
    @AppStorage("nickname") var nickname: String = ""

    @State private var isURLValid: Bool = true
    @State private var areFieldsValid: Bool = true
    @State private var saveMessage: String = ""
    @State private var isError: Bool = false // メッセージのエラー状態
    @State private var showFlashAnimation: Bool = false // フラッシュアニメーション用
    @State private var showSdkStatePopup: Bool = false // ポップアップ表示用
    @State private var sdkState: String = "" // SDKの状態出力用
    @State private var showSdkStateModal: Bool = false // モーダル表示用

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // タブ切り替えのナビゲーション
                HStack {
                    Button(action: {
                        selectedTab = "Push設定"
                        loadSettings()
                    }) {
                        Text("Push設定")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedTab == "Push設定" ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        selectedTab = "連絡先設定"
                        loadSettings()
                    }) {
                        Text("連絡先設定")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedTab == "連絡先設定" ? Color.green : Color.gray.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                HStack {
                    Text("\(selectedTab)")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button(action: {
                        getSdkState()
                    }) {
                        Text("状態確認")
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)

                // 各タブの内容を表示
                if selectedTab == "Push設定" {
                    Group {
                        Text("MID")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("MID", text: $mid)
                            .padding()
                            .background(validateMID(mid) ? Color(.secondarySystemBackground) : Color.red.opacity(0.2))
                            .cornerRadius(10)
                            .onChange(of: mid) { newValue in
                                mid = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                    }
                    .padding(.horizontal)

                    Group {
                        Text("App ID")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("App ID", text: $appId)
                            .padding()
                            .background(validateAppID(appId) ? Color(.secondarySystemBackground) : Color.red.opacity(0.2))
                            .cornerRadius(10)
                            .onChange(of: appId) { newValue in
                                appId = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                    }
                    .padding(.horizontal)

                    Group {
                        Text("Token")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Token", text: $token)
                            .padding()
                            .background(validateToken(token) ? Color(.secondarySystemBackground) : Color.red.opacity(0.2))
                            .cornerRadius(10)
                            .onChange(of: token) { newValue in
                                token = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                    }
                    .padding(.horizontal)

                    Group {
                        Text("URL")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("URL", text: $url)
                            .padding()
                            .background(validateURL(url) ? Color(.secondarySystemBackground) : Color.red.opacity(0.2))
                            .cornerRadius(10)
                            .onChange(of: url) { newValue in
                                url = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                                _ = validateURL(newValue)
                            }
                    }
                    .padding(.horizontal)

                    Button(action: {
                        let validationMessage = validateAllFields()
                        if validationMessage.isEmpty {
                            saveSettings()
                            saveMessage = "Push設定の保存が完了しました。反映のためアプリを再起動してください。"
                            isError = false
                            showFlashAnimation = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showFlashAnimation = false
                            }
                        } else {
                            saveMessage = validationMessage
                            isError = true
                            showFlashAnimation = false
                        }
                    }) {
                        Text("保存")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                } else if selectedTab == "連絡先設定" {
                    Group {
                        Text("会員ID")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("会員ID", text: $memberId)
                            .padding()
                            .background(memberId.isEmpty ? Color.red.opacity(0.2) : Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    Group {
                        Text("お名前")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("お名前", text: $nickname)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    Button(action: {
                        
                        if validateContactFields() {
                            saveSettings()
                            saveMessage = "連絡先設定を保存しました。"
                            isError = false
                            showFlashAnimation = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showFlashAnimation = false
                            }
                            
                            
                            // ここに書くンゴ（setContactボタン押下時の処理を追加）
                            print("setContactボタンが押されました！")
                            // Set contact key for all modules
                        
                            SFMCSdk.identity.setProfileId(memberId)
                            SFMCSdk.identity.setProfileAttributes(["firstName": nickname])

                            
                            
                        } else {
                            saveMessage = "会員IDを入力してください。"
                            isError = true
                            showFlashAnimation = false
                        }
                    }) {
                        Text("setContact")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }

                // メッセージ表示（エラーか成功で色を切り替え）
                if !saveMessage.isEmpty {
                    Text(saveMessage)
                        .font(.headline)
                        .padding()
                        .foregroundColor(isError ? .red : .blue)
                }

                Spacer().frame(height: 40) // フッターにスペースを追加
            }
        }
        .onAppear {
            loadSettings()
        }
        .sheet(isPresented: $showSdkStateModal) {
            SdkStateModalView(sdkState: sdkState) // モーダル表示
        }
    }
    
    // SDKの状態を取得
    private func getSdkState() {
        
        let state = SFMCSdk.state()
        sdkState = !state.isEmpty ? state : "SDK状態を取得できませんでした。"
        print("SDK状態ローカル: \(sdkState)")
        
        DispatchQueue.main.async {
            showSdkStateModal = true
        }
    }
    
    func saveSettings() {
        UserDefaults.standard.set(mid, forKey: "mid")
        UserDefaults.standard.set(appId, forKey: "appId")
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(url, forKey: "url")
        UserDefaults.standard.set(memberId, forKey: "memberId")
        UserDefaults.standard.set(nickname, forKey: "nickname")
    }

    func loadSettings() {
        mid = UserDefaults.standard.string(forKey: "mid") ?? ""
        appId = UserDefaults.standard.string(forKey: "appId") ?? ""
        token = UserDefaults.standard.string(forKey: "token") ?? ""
        url = UserDefaults.standard.string(forKey: "url") ?? ""
        memberId = UserDefaults.standard.string(forKey: "memberId") ?? ""
        nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
    }
    
    func validateURL(_ urlString: String) -> Bool {
        guard !urlString.isEmpty, let url = URL(string: urlString), url.scheme == "https" else {
            return false
        }
        return true
    }

    func validateMID(_ mid: String) -> Bool {
        return !mid.isEmpty && Int(mid) != nil
    }

    func validateAppID(_ appId: String) -> Bool {
        let uuidRegex = "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", uuidRegex)
        return predicate.evaluate(with: appId)
    }

    func validateToken(_ token: String) -> Bool {
        let tokenRegex = "^[a-zA-Z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", tokenRegex)
        return predicate.evaluate(with: token)
    }

    func validateAllFields() -> String {
        var errors: [String] = []
        if !validateMID(mid) {
            errors.append("MIDは数字のみで入力してください。")
        }
        if !validateAppID(appId) {
            errors.append("App IDはUUID形式で入力してください。")
        }
        if !validateToken(token) {
            errors.append("Tokenは英数字のみで入力してください。")
        }
        if !validateURL(url) {
            errors.append("URLはHTTPSで始まる形式で入力してください。")
        }
        return errors.joined(separator: "\n")
    }

    func validateContactFields() -> Bool {
        return !memberId.isEmpty
    }
}


// SDK状態表示用のモーダルビュー
struct SdkStateModalView: View {
    let sdkState: String

    var body: some View {
        NavigationView {
            ScrollView {
                Text(sdkState)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationTitle("SDK状態")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") {
                        // モーダルを閉じる
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
