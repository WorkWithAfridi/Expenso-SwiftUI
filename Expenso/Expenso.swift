import SwiftUI

@main
struct ExpensoApp: App {
  let persistenceController = PersistenceController.shared
  @StateObject var themeProvider = ThemeProvider()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .environmentObject(themeProvider)
    }
  }
}
