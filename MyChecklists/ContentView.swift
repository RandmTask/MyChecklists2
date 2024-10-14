import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var checklists: [Checklist]
    @State private var showingAddChecklist = false
    @AppStorage("hasAddedSampleData") private var hasAddedSampleData = false

    var body: some View {
        NavigationView {
            List {
                ForEach(checklists) { checklist in
                    NavigationLink(destination: ChecklistDetailView(checklist: checklist)) {
                        Text(checklist.name)
                    }
                }
                .onDelete(perform: deleteChecklists)
            }
            .navigationTitle("Checklists")
            .navigationBarItems(trailing: Button(action: {
                showingAddChecklist = true
            }) {
                Image(systemName: "plus")
            })
            
        }
        .sheet(isPresented: $showingAddChecklist) {
            AddChecklistView()
        }
        .onAppear {
            if !hasAddedSampleData {
                addSampleData()
                hasAddedSampleData = true
            }
        }
    }

    private func deleteChecklists(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(checklists[index])
            }
        }
    }

    private func addSampleData() {
        for checklist in Checklist.sampleData {
            modelContext.insert(checklist)
        }
    }
}
