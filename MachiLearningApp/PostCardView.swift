import SwiftUI

struct PostCardView: View {
    let post: Post
    @State private var isLiked: Bool = false
    @State private var heartSize: CGFloat = 1.0

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(post.date)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(post.content)
                .font(.body)

            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeIn(duration: 0.3)) {
                        self.isLiked.toggle()
                        self.heartSize = self.isLiked ? 1.5 : 1.0
                    }
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(isLiked ? .red : .gray)
                        .scaleEffect(heartSize)
                        .animation(.spring(), value: heartSize)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
