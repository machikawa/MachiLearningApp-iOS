import SwiftUI

struct ProductDetailView: View {
    var productName: String
    @State private var showMessage: String? = nil // メッセージを表示するための状態
    @State private var showCheatCodeInput: Bool = false // チートコード入力フィールドの表示を管理
    @State private var cheatCode: String = "" // チートコードを入力するための状態
    @State private var selectedQuantity: Int = 1 // 個数の選択状態

    var body: some View {
        VStack(spacing: 20) {
            // 上部の控えめなチートコードラベル
            HStack {
                Spacer() // 右寄せにするためのスペーサー
                Button(action: {
                    showCheatCodeInput.toggle() // チートコード入力フィールドの表示を切り替え
                }) {
                    HStack {
                        Image(systemName: "key.fill") // チートコード用のアイコン
                            .imageScale(.large)
                            .font(.system(size: 20))  // ラベルのフォントサイズ
                        
                        Text("チートコード")
                            .font(.title3) // ラベルのフォントサイズを控えめに
                            .foregroundColor(.primary)
                    }
                }
                .padding([.top, .trailing], 20) // 上部と右側に余白をつける
            }

            Text("\(productName) の詳細")
                .font(.largeTitle)
                .padding()

            // チートコード入力フィールド
            if showCheatCodeInput {
                TextField("任意のProduct IDを設定できます。", text: $cheatCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            // 個数の選択（プルダウン）
            HStack {
                Text("個数:")
                    .font(.title2)
                Picker("個数", selection: $selectedQuantity) {
                    ForEach(1..<11) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(WheelPickerStyle()) // プルダウンのスタイルを変更可能
                .frame(height: 100) // 高さを調整
            }
            .padding()

            // ボタン: お気に入り
            Button(action: {
                showMessage = "お気に入りに追加しました！"
            }) {
                Text("お気に入りに追加")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // ボタン: カートに入れる
            Button(action: {
                showMessage = "カートに追加しました！（個数: \(selectedQuantity)）"
            }) {
                Text("カートに入れる")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // ボタン: 購入
            Button(action: {
                showMessage = "購入しました！（個数: \(selectedQuantity)）"
            }) {
                Text("購入する")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // アクション結果のメッセージ表示
            if let message = showMessage {
                Text(message)
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding(.top, 20)
                    .transition(.opacity) // アニメーション付きで表示
            }

            Spacer() // スペーサーで下に詰める
        }
        .padding()
        .animation(.easeInOut, value: showMessage) // メッセージのアニメーション
    }
}
