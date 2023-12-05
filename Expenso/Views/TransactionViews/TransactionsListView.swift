import SwiftUI
import CoreData

struct TransactionsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: TransactionsViewModel
    
    @State private var isShowingNewTransactionView = false
    @State private var showingAlert = false
    @State private  var offsets: IndexSet?
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: TransactionsViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Category", selection: $viewModel.selectedCategory) {
                    Text("All").tag("All")
                    Text("Food").tag("Food")
                    Text("Home").tag("Home")
                    Text("Work").tag("Work")
                    Text("Transportation").tag("Transportation")
                    Text("Entertainment").tag("Entertainment")
                    Text("Leisure").tag("Leisure")
                    Text("Health").tag("Health")
                    Text("Gift").tag("Gift")
                    Text("Shopping").tag("Shopping")
                    Text("Investment").tag("Investment")
                    Text("Other").tag("Other")
                }
                .pickerStyle(MenuPickerStyle())
                .padding([.horizontal, .top])
                
                Spacer()
                
                if viewModel.transactions.isEmpty {
                    emptyTransactionsView
                } else {
                    transactionListView
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle("transactions".localized(language))
            .navigationBarItems(
                trailing: Button(action: {
                    isShowingNewTransactionView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                }
            )
            .sheet(isPresented: $isShowingNewTransactionView) {
                NewTransactionView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    var emptyTransactionsView: some View {
        VStack {
            Spacer()
            
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(.gray)
                .padding()
            Text("no_transactions_yet".localized(language))
                .font(.headline)
                .padding(.bottom, 1)
                .multilineTextAlignment(.center)
            Text("tap_+_to_add".localized(language))
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
    
    var transactionListView: some View {
        List {
            ForEach(viewModel.transactions, id: \.self) { transaction in
                TransactionRow(transaction: transaction)
            }
            .onDelete(perform: { indexSet in
                self.offsets = indexSet
                showingAlert.toggle()
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Are you sure?"),
                      message: Text("This will permanently delete your data. This action can't be undone."),
                      primaryButton: .destructive(Text("Delete")) {
                    if let safeOffset = offsets {
                        viewModel.deleteTransactions(
                            at: safeOffset)
                    }
                },
                      secondaryButton: .cancel()
                )
            }
            
            if !viewModel.transactions.isEmpty {
                Text("Total: \(viewModel.totalAmount < 0 ? "-" : "")$\((abs(viewModel.totalAmount)), specifier: "%.2f")")
                    .font(.headline)
                    .padding(.top, 10)
            }
        }
    }
}

#Preview {
    TransactionsListView(context: PersistenceController.preview.container.viewContext)
}


