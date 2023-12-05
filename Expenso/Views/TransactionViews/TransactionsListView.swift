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
                HStack{
                    Text("transactions".localized(language))
                        .font(.title)
                        .bold()
                    Spacer()
                    Button(action: {
                        isShowingNewTransactionView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                HStack(alignment: .center){
                    Spacer()
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        Text("All".localized(language)).tag("All")
                        Text("Food".localized(language)).tag("Food")
                        Text("Home".localized(language)).tag("Home")
                        Text("Work".localized(language)).tag("Work")
                        Text("Transportation".localized(language)).tag("Transportation")
                        Text("Entertainment".localized(language)).tag("Entertainment")
                        Text("Leisure".localized(language)).tag("Leisure")
                        Text("Health".localized(language)).tag("Health")
                        Text("Gift".localized(language)).tag("Gift")
                        Text("Shopping".localized(language)).tag("Shopping")
                        Text("Investment".localized(language)).tag("Investment")
                        Text("Other".localized(language)).tag("Other")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding([.horizontal])
                }
                
                Spacer()
                
                if viewModel.transactions.isEmpty {
                    emptyTransactionsView
                } else {
                    transactionListView
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
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
            // Gestures
            .onDelete(perform: { indexSet in
                self.offsets = indexSet
                showingAlert.toggle()
            })
            
            // Dialoge
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("are_you_sure".localized(language)),
                      message: Text("this_will_permanently_delete".localized(language)),
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


