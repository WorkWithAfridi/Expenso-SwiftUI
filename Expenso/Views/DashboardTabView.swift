import SwiftUI

struct DashboardTabView: View {
  @Environment(\.managedObjectContext) private var viewContext
  var logoutAction: () -> Void
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
  var body: some View {
      TabView {
        TransactionsListView(context: viewContext)
          .tabItem {
            Image(systemName: "list.dash")
            Text("transactions".localized(language))
          }
        SettingsView()
          .tabItem {
            Image(systemName: "gearshape")
            Text("settings".localized(language))
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
