import SwiftUI

struct ColoredTitleView: View {
  var body: some View {
    HStack {
      Text("Welcome to")
      Text("Expenso").foregroundColor(Color("ExpensoPink"))
    }
    .font(.largeTitle)
    .bold()
  }
}

#Preview {
  ColoredTitleView()
}
