import SwiftUI

struct NotificationsView: View {
    let notifications = [
        "お知らせ1: 重要なアップデート",
        "お知らせ2: メンテナンス情報",
        "お知らせ3: 新機能リリース",
        "お知らせ4: システム障害情報",
        "お知らせ5: サービス復旧のお知らせ"
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(notifications, id: \.self) { notification in
                    HStack(alignment: .top) {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                            .padding(.top, 8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(notification)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("3時間前")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()

                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .padding(.top, 8)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("お知らせ")
    }
}
