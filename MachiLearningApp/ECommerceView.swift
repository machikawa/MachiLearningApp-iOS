import SwiftUI

struct ECommerceView: View {
    var body: some View {
        List {
            NavigationLink(destination: ProductDetailView(productName: "商品1")) {
                HStack {
                    Image(systemName: "cart")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("商品1")
                }
            }
            NavigationLink(destination: ProductDetailView(productName: "商品2")) {
                HStack {
                    Image(systemName: "cart.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("商品2")
                }
            }
            NavigationLink(destination: ProductDetailView(productName: "商品3")) {
                HStack {
                    Image(systemName: "cart.badge.plus")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("商品3")
                }
            }
        }
        .navigationTitle("商品一覧")
    }
}
