import CodeScanner
import SwiftData
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    @Environment(\.modelContext) private var modelContext
    
    enum ProspectType {
        case everyone, contacted, uncontacted
    }
    
    let prospectType: ProspectType
    
    private var title: String {
        switch prospectType {
        case .everyone:
            "Everyone"
        case .contacted:
            "Contacted People"
        case .uncontacted:
            "Uncontacted People"
        }
    }
    
    @State private var selectedProspects: Set<Prospect> = []
    @State private var isShowingScanner: Bool = false
    @State private var sortOrder = [
        SortDescriptor<Prospect>(\.name)
    ]
    
    //MARK: Body
    var body: some View {
        NavigationStack {
            ProspectListView(
                prospectType: prospectType,
                selectedProspects: $selectedProspects,
                sortOrder: sortOrder
            ).navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("Sort By") {
                            Picker("Sort By", selection: $sortOrder) {
                                Text("Name").tag(
                                    [
                                        SortDescriptor<Prospect>(\.name)
                                    ]
                                )
                                Text("Most Recent").tag(
                                    [
                                        SortDescriptor<Prospect>(\.createdAt)
                                    ]
                                )
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Scan", systemImage: "qrcode.viewfinder") {
                            isShowingScanner = true
                        }.tint(.mint)
                    }
                    if !selectedProspects.isEmpty {
                        ToolbarItem(placement: .bottomBar) {
                            Button("Delete", role: .destructive) {
                                deleteAllSelectedProspects()
                            }.tint(.red)
                        }
                    }
                }
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(
                        codeTypes: [.qr],
                        simulatedData: "Example\nexample@gmail.com"
                    ) { result in
                        handleScanningResult(result: result)
                    }
                }
                .onAppear {
                    selectedProspects.removeAll()
                }
        }
    }
    
    private func handleScanningResult(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let scanResult):
            let details = scanResult.string.components(separatedBy: "\n")
            guard details.count == 2 else {
                return
            }
            let prospect = Prospect(
                name: details[0],
                emailAddress: details[1],
                isContacted: false
            )
            modelContext.insert(prospect)
        case .failure(let scanError):
            print("Scanning Failed: \(scanError.localizedDescription)")
        }
        isShowingScanner = false
    }
    
    private func deleteAllSelectedProspects() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
        selectedProspects.removeAll()
    }
}

#Preview {
    ProspectsView(
        prospectType: .everyone
    )
}
