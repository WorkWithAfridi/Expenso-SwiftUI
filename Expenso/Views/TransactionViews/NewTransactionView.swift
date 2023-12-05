import CoreData
import SwiftUI

struct NewTransactionView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var themeProvider: ThemeProvider
  
  @State private var name = ""
  @State private var amount = ""
  @State private var selectedSegment = 0
  @State private var selectedCategoryIndex = 0
  
  @State private var showErrorAlert = false
  @State private var errorMessage = "There was a problem saving the transaction. Please try again."
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
  
  let categories = ["Food", "Home", "Work", "Transportation", "Entertainment", "Leisure", "Health", "Gift", "Shopping", "Investment", "Other"]
  
  var body: some View {
    NavigationView {
      Form {
        TextField("name".localized(language), text: $name)
        
        HStack {
          Text("$")
          TextField("amount".localized(language), text: $amount)
            .keyboardType(.decimalPad)
        }
        
        Picker("Type", selection: $selectedSegment) {
          Text("income".localized(language)).tag(0)
          Text("expense".localized(language)).tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        
        Picker("category".localized(language), selection: $selectedCategoryIndex) {
          ForEach(Array(categories.indices), id: \.self) { index in
              Text(self.categories[index].localized(language)).tag(index)
          }
        }
      }
      .navigationTitle("add_transactions".localized(language))
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("save".localized(language)) {
            saveTransaction()
          }
          .accentColor(Color("ExpensoPink"))
        }
      }
        // Dialoge
      .alert(isPresented: $showErrorAlert) {
        Alert(
            title: Text("save_error".localized(language)),
          message: Text(errorMessage),
          dismissButton: .default(Text("OK"))
        )
      }
    }
    .colorScheme(themeProvider.isDarkMode ? .dark : .light)
  }
  
  private func saveTransaction() {
    guard let amountDouble = Double(self.amount), !self.name.isEmpty else {
        self.errorMessage = "pls_fill_up_correctly".localized(language)
      self.showErrorAlert = true
      return
    }
    
    let newTransaction = Transaction(context: viewContext)
    newTransaction.name = self.name
    newTransaction.amount = amountDouble
    newTransaction.type = Int16(self.selectedSegment)
    newTransaction.category = self.categories[selectedCategoryIndex]
    newTransaction.date = Date()
    newTransaction.id = UUID()
    
    do {
      try viewContext.save()
      dismiss()
    } catch {
      let nsError = error as NSError
      print("Unresolved error \(nsError), \(nsError.userInfo)")
      self.errorMessage = "There was a problem saving the transaction. Please try again."
      self.showErrorAlert = true
    }
  }
}

#Preview {
  NewTransactionView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
