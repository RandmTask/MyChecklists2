import SwiftUI

struct EditChecklistView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var checklist: Checklist

    var body: some View {
        NavigationView {
            Form {
                TextField("Checklist Name", text: $checklist.name)
            }
            .navigationTitle("Edit Checklist")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    dismiss()
                }
            )
        }
    }
}

//#Preview {
//    EditChecklistView()
//}
