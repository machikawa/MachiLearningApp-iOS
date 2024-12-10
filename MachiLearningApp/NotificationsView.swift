import SwiftUI
import MarketingCloudSDK
import SFMCSDK


struct NotificationsView: View {
    @State private var messages: [InboxMessage] = []
    @State private var isRefreshing = false

    var body: some View {
        NavigationView {
//                // 背景画像をぼかして表示
//                Image("sakura")
//                    .resizable()
//                    .scaledToFill()
//                    .ignoresSafeArea()
//                    .blur(radius: 5)

                GeometryReader { geometry in // GeometryReaderで画面サイズを取得
                    

                        // リストビュー
                        List(messages) { message in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(message.subject)
                                    .font(.system(size: 18, weight: .semibold))

                                Text("お知らせ日時 \(formatDate(message.date))")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(message.isRead ? Color.gray.opacity(0.1) : Color.blue.opacity(0.2))
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(message.isRead ? Color.clear : Color.blue, lineWidth: 2)
                            )
                            .overlay(
                                HStack {
                                    Spacer()
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(message.isRead ? .gray : .blue)
                                        .padding(.trailing, 8)
                                }
                            )
                            .onTapGesture {
                                handleTap(on: message)
                            }
                        }
                        .listStyle(.plain)
                        .background(Color.clear)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        // リストの高さを画面サイズの70%に制限
                        .frame(maxHeight: geometry.size.height * 0.7)
                        .onAppear {
                            Task {
                                await loadMessages()
                            }
                        }
                        .refreshable {
                            await refreshMessages()
                        }
                    
                }
            
            .navigationTitle("お知らせ一覧 (inbox)")
        }
    }
    
    
    func refreshMessages() async {
        isRefreshing = true
        await withCheckedContinuation { continuation in
            SFMCSdk.requestPushSdk { sdk in
                if sdk.refreshMessages() == false {
                    DispatchQueue.main.async {
                        isRefreshing = false
                        continuation.resume()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isRefreshing = false
                        continuation.resume()
                    }
                }
            }
        }
        await loadMessages()
    }

    func loadMessages() async {
        await withCheckedContinuation { continuation in
            SFMCSdk.requestPushSdk { sdk in
                if let inboxArray = sdk.getAllMessages() as? [[String: Any]] {
                    messages = inboxArray.compactMap { dictionary in
                        InboxMessage.from(dictionary: dictionary)
                    }.sorted(by: { $0.date > $1.date })
                }
                continuation.resume()
            }
        }
    }

    func handleTap(on message: InboxMessage) {
        SFMCSdk.requestPushSdk { sdk in
            sdk.trackMessageOpened(message.rawData)
            _ = sdk.markMessageRead(message.rawData)
        }

        if let url = URL(string: message.url) {
            UIApplication.shared.open(url)
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "YYYY年MM月dd日 HH:mm"
        return formatter.string(from: date)
    }
}

// メッセージモデル
struct InboxMessage: Identifiable, Hashable {
    let id: String
    let subject: String
    let sendDateUtc: String
    let url: String
    let isRead: Bool
    let rawData: [String: Any]
    let date: Date

    // Equatableの実装
    static func == (lhs: InboxMessage, rhs: InboxMessage) -> Bool {
        return lhs.id == rhs.id &&
               lhs.subject == rhs.subject &&
               lhs.sendDateUtc == rhs.sendDateUtc &&
               lhs.url == rhs.url &&
               lhs.isRead == rhs.isRead &&
               lhs.date == rhs.date
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(subject)
        hasher.combine(sendDateUtc)
        hasher.combine(url)
        hasher.combine(isRead)
        hasher.combine(date)
    }

    static func from(dictionary: [String: Any]) -> InboxMessage? {
        guard let id = dictionary["id"] as? String,
              let subject = dictionary["subject"] as? String,
              let sendDateUtc = dictionary["sendDateUtc"] as? Date,
              let url = dictionary["url"] as? String,
              let isRead = dictionary["read"] as? Bool else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        return InboxMessage(
            id: id,
            subject: subject,
            sendDateUtc: dateFormatter.string(from: sendDateUtc),
            url: url,
            isRead: isRead,
            rawData: dictionary,
            date: sendDateUtc
        )
    }
}
