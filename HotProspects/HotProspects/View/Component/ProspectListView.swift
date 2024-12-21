import SwiftData
import SwiftUI
import UserNotifications

struct ProspectListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var prospects: [Prospect]
    
    let prospectType: ProspectsView.ProspectType
    @Binding var selectedProspects: Set<Prospect>
    
    init(
        prospectType: ProspectsView.ProspectType,
        selectedProspects: Binding<Set<Prospect>>,
        sortOrder: [SortDescriptor<Prospect>]
    ) {
        self.prospectType = prospectType
        self._selectedProspects = selectedProspects
        if prospectType != .everyone {
            let showContactedOnly = (prospectType == .contacted)
            _prospects = Query(filter: #Predicate { prospect in
                prospect.isContacted == showContactedOnly
            }, sort: sortOrder)
        } else {
            _prospects = Query(
                sort: sortOrder
            )
        }
    }
    
    //MARK: BODY
    var body: some View {
        List(prospects, selection: $selectedProspects) { prospect in
            NavigationLink {
                EditProspectView(
                    prospect: prospect
                )
            } label: {
                ProspectItemView(
                    prospect: prospect,
                    prospectType: prospectType
                ).swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }.tint(.red)
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }.tint(.blue)
                    } else {
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }.tint(.green)
                        Button("Remind Me", systemImage: "bell") {
                            addNotification(for: prospect)
                        }.tint(.orange)
                    }
                }
            }.tag(prospect)
        }.toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
                    .tint(.mint)
            }
        }
    }
    
    private func addNotification(for prospect: Prospect) {
        let notificationCenter = UNUserNotificationCenter.current()

        let addRequest = {
            let identifier = UUID().uuidString
            
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = .default
            
            //trigger (production)
//            var dateComponents = DateComponents()
//            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(
//                dateMatching: dateComponents,
//                repeats: false
//            )
            
            //trigger (testing)
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: 5,
                repeats: false
            )
            
            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )
            
            notificationCenter.add(request)
        }

        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
