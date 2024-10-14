// Created in Oct 2024

import SwiftUI
import SwiftData

struct ChecklistItemView: View {
    // Bindable allows us to modify the item properties
    @Bindable var item: ChecklistItem
    
    var body: some View {
        // Main item row layout
        HStack {
            // Checkmark circle that toggles between filled and empty
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isCompleted ? .green : .gray)
            
            // Item title with strikethrough when completed
            Text(item.title)
                .strikethrough(item.isCompleted)
            
            Spacer()
        }
        // Make the entire row tappable
        .contentShape(Rectangle())
        .onTapGesture {
            // Toggle completion status and update completion date
            item.isCompleted.toggle()
            item.completionDate = item.isCompleted ? Date() : nil
        }
        // Reduce opacity for completed items
        .opacity(item.isCompleted ? 0.5 : 1.0)
    }
}
