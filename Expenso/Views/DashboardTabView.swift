import SwiftUI

struct DashboardTabView: View {
  @Environment(\.managedObjectContext) private var viewContext
  var logoutAction: () -> Void
  
  var body: some View {
      TabView {
        TransactionsListView(context: viewContext)
          .tabItem {
            Image(systemName: "list.dash")
            Text("Transactions")
          }
        SettingsView()
          .tabItem {
            Image(systemName: "gearshape")
            Text("Settings")
          }
      }
      .accentColor(Color("ExpensoPink"))
  }
}

#Preview {
  DashboardTabView {
    print("Logout action performed")
  }
}
