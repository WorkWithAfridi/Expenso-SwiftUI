import CoreData
import SwiftUI

struct SettingsView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @EnvironmentObject var themeProvider: ThemeProvider
  
  @State private var showingAlert = false
  @State private var showErrorAlert = false
  
  @State private var errorTitle = ""
  @State private var errorMessage = ""
  
  var body: some View {
    NavigationView {
      Form {
        Picker("Theme", selection: $themeProvider.isDarkMode) {
          Text("Light").tag(false)
          Text("Dark").tag(true)
        }
        .pickerStyle(SegmentedPickerStyle())
        
        Section {
          Button(action: {
            showingAlert = true
          }) {
            Text("Delete My Data")
              .foregroundColor(.red)
          }
          .alert(isPresented: $showingAlert) {
            Alert(title: Text("Are you sure?"),
                  message: Text("This will permanently delete all your data. This action can't be undone."),
                  primaryButton: .destructive(Text("Delete")) {
              deleteUserData()
            },
                  secondaryButton: .cancel()
            )
          }
        } header: {
          Text("Data Management")
        }
      }
      .navigationTitle("Settings")
      .alert(isPresented: $showErrorAlert) {
        Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
      }
    }
  }

  func deleteUserData() {
    let entities = ["Budget", "SavingsGoal", "Transaction"]
    
    for entity in entities {
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      do {
        try viewContext.execute(batchDeleteRequest)
      } catch {
        self.errorTitle = "Delete Error"
        self.errorMessage = "There was a problem deleting your data."
        self.showErrorAlert = true
        return
      }
    }
    
    do {
      try viewContext.save()
    } catch {
      self.errorTitle = "Save Error"
      self.errorMessage = "There was a problem saving the changes."
      self.showErrorAlert = true
    }
  }
}

#Preview {
  SettingsView()
}
