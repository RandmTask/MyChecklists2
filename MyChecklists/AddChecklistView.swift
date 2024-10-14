////
////  AddChecklistView.swift
////  MyChecklists
////
////  Created by Deon O'Brien on 14/10/24.
////
//
//import SwiftUI
//
//struct AddChecklistView: View {
//    @Binding var checklists: [Checklist]
//    @State private var checklistName = ""
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        NavigationView {
//            Form {
//                TextField("Checklist Name", text: $checklistName)
//            }
//            .navigationTitle("Add Checklist")
//            .navigationBarItems(leading: Button("Cancel") {
//                presentationMode.wrappedValue.dismiss()
//            }, trailing: Button("Save") {
//                let newChecklist = Checklist(name: checklistName, items: [])
//                checklists.append(newChecklist)
//                presentationMode.wrappedValue.dismiss()
//            })
//        }
//    }
//}
//
////#Preview {
////    AddChecklistView()
////}


import SwiftUI
import SwiftData

struct AddChecklistView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var checklistName = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Checklist Name", text: $checklistName)
            }
            .navigationTitle("Add Checklist")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Save") {
                let newChecklist = Checklist(name: checklistName)
                modelContext.insert(newChecklist)
                dismiss()
            })
        }
    }
}
