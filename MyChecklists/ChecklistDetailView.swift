// Created in Oct 2024

import SwiftUI
import SwiftData

struct ChecklistDetailView: View {
    @Bindable var checklist: Checklist
    @State private var newItemTitle = ""
    @State private var isAddingItem = false
    @FocusState private var isNewItemFieldFocused: Bool
    
    var body: some View {
        ZStack {
            List {
                ForEach(sections, id: \.0) { section in
                    if let header = section.0 {
                        // This will place the completed items in the gray background
                        Section(header: Text(header)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .textCase(nil)) {
                                ForEach(section.1) { item in
                                    ChecklistItemView(item: item)
                                }
                        }
                    } else {
                        // Regular items stay in the white background
                        ForEach(section.1) { item in
                            ChecklistItemView(item: item)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
                .onMove(perform: moveItems)
            }
            .toolbar {
                EditButton() // This enables the drag handles in edit mode
            }
            .navigationTitle(checklist.name)
            .navigationBarItems(trailing: menuButton)
            
            // Floating add button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isAddingItem = true
                        isNewItemFieldFocused = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding()
                    .opacity(isAddingItem ? 0 : 1)
                }
            }
        }
        .overlay(
            VStack {
                Spacer()
                if isAddingItem {
                    HStack {
                        // Text input field for new tasks.
                        TextField("New item", text: $newItemTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isNewItemFieldFocused)
                            .submitLabel(.done) // Change the return key to "Submit"
                            .onSubmit {
                                                    if newItemTitle.isEmpty {
                                                        // Dismiss the keyboard and input field if no text is entered
                                                        withAnimation {
                                                            isNewItemFieldFocused = false
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                                isAddingItem = false
                                                            }
                                                        }
                                                    } else {
                                                        addItem()
                                                    }
                                                }
                        
                        // Dynamic button that changes based on text input
                        if newItemTitle.isEmpty {
                            // Shows keyboard dismiss icon when no text is entered
                            // Tapping it will dismiss both keyboard and input field
                            // When text field is empty - show subtle keyboard dismiss icon
                            // When text field is empty - show subtle keyboard dismiss symbol
                            Button(action: {
                                // Wrap both state changes in a single animation block
                                withAnimation {
                                    isNewItemFieldFocused = false
                                    // Small delay before hiding the input field
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        isAddingItem = false
                                    }
                                }
                            }) {
                                Image(systemName: "keyboard.chevron.compact.down")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.gray)
                            }


                        } else {
                            // Shows submit arrow when text is present
                            // Tapping it will add the new task
                            Button(action: addItem) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .transition(.move(edge: .bottom))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
            .onTapGesture {
                // Tapping outside the input area dismisses both keyboard and input field
                if isAddingItem {
                    isAddingItem = false
                    isNewItemFieldFocused = false
                }
            }
        )

    }
    
    // Menu button with sort and filter options
    var menuButton: some View {
        Menu {
            Menu {
                Picker("Sort", selection: $checklist.sortOption) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Text(option.description).tag(option)
                    }
                }
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
            
            Menu {
                Picker("Filter", selection: $checklist.filterOption) {
                    ForEach(FilterOption.allCases, id: \.self) { option in
                        Text(option.description).tag(option)
                    }
                }
            } label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    
    // Computed property to organize items into sections
    var sections: [(String?, [ChecklistItem])] {
        if checklist.filterOption == .completedAtBottom {
            let incomplete = sortedAndFilteredItems.filter { !$0.isCompleted }
            let completed = sortedAndFilteredItems.filter { $0.isCompleted }
            return [
                (nil, incomplete),
                (completed.isEmpty ? nil : "Completed Items", completed)
            ].compactMap { header, items in
                items.isEmpty ? nil : (header, items)
            }
        }
        return [(nil, sortedAndFilteredItems)]
    }
    
    // Main sorting and filtering logic
    var sortedAndFilteredItems: [ChecklistItem] {
        var items = checklist.items
        
        switch checklist.filterOption {
        case .all: break
        case .incomplete: items = items.filter { !$0.isCompleted }
        case .completed:
            // Show only completed items, sorted by completion date
            return items.filter { $0.isCompleted }
                .sorted { $0.completionDate ?? Date.distantPast > $1.completionDate ?? Date.distantPast }
        case .completedAtBottom:
            let incompleteItems = items.filter { !$0.isCompleted }
            let completedItems = items.filter { $0.isCompleted }
                .sorted { $0.completionDate ?? Date.distantPast > $1.completionDate ?? Date.distantPast }
            
            return incompleteItems + completedItems
        }
        
        if checklist.sortOption == .alphabetical {
            return items.sorted { $0.title.lowercased() < $1.title.lowercased() }
        }
        
        return items
    }
    
    // Add new item function
    func addItem() {
        let trimmedTitle = newItemTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTitle.isEmpty {
            let newItem = ChecklistItem(title: trimmedTitle)
            checklist.items.append(newItem)
        }
        
        newItemTitle = ""
        
        DispatchQueue.main.async {
            isNewItemFieldFocused = true
        }
    }
    
    // Delete items function
    func deleteItems(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { sortedAndFilteredItems[$0] }
        checklist.items.removeAll(where: { item in
            itemsToDelete.contains(where: { $0.id == item.id })
        })
    }
    
    // Move items function
    func moveItems(from source: IndexSet, to destination: Int) {
        checklist.items.move(fromOffsets: source, toOffset: destination)
    }
}
