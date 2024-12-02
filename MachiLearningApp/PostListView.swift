import SwiftUI

struct PostListView: View {
    let posts = [
        Post(id: 1, date: "2024/10/21", content: "教育に関する投稿内容1"),
        Post(id: 2, date: "2024/10/20", content: "教育に関する投稿内容2"),
        Post(id: 3, date: "2024/10/19", content: "教育に関する投稿内容3")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(posts) { post in
                    PostCardView(post: post)
                }
            }
            .padding()
        }
    }
}
