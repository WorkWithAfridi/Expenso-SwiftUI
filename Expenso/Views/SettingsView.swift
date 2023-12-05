import CoreData
import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var themeProvider: ThemeProvider
    
    @State private var showingAlert = false
    @State private var showErrorAlert = false
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    @State private var isEnglishSelected = true
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var body: some View {
        NavigationView {
            Form {
                Picker("theme".localized(language), selection: $themeProvider.isDarkMode) {
                    Text("light".localized(language)).tag(false)
                    Text("dark".localized(language)).tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Section{
                    Menu {
                        Button {
                            LocalizationService.shared.language = .english_us
                        } label: {
                            Text("English (US)")
                        }
                        Button {
                            LocalizationService.shared.language = .german
                        } label: {
                            Text("German (DE)")
                        }
                    } label: {
                        Text("\("app_language".localized(language)): ")
                        Spacer()
                        Text("\("\(LocalizationService.shared.language.rawValue)".lowercased() == "en" ? "English (US)" : "German (DE)" )".localized(language).uppercased())
                    }.padding()
                } header: {
                    Text("locale".localized(language))
                }
                
                Section {
                    Button(action: {
                        showingAlert = true
                    }) {
                        Text("delete_my_data".localized(language))
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("are_you_sure".localized(language)),
                              message: Text("this_will_permanently_delete".localized(language)),
                              primaryButton: .destructive(Text("Delete")) {
                            deleteUserData()
                        },
                              secondaryButton: .cancel()
                        )
                    }
                } header: {
                    Text("data_management".localized(language))
                }
            }
            .navigationTitle("settings".localized(language))
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
                self.errorTitle = "delete_error".localized(language)
                self.errorMessage = ""
                self.showErrorAlert = true
                return
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            self.errorTitle = "save_error".localized(language)
            self.errorMessage = ""
            self.showErrorAlert = true
        }
    }
}

#Preview {
    SettingsView()
}
