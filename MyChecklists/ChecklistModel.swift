import Foundation
import SwiftData

@Model
class Checklist {
    @Attribute(.unique) var id: String
    var name: String
    @Relationship(deleteRule: .cascade) var items: [ChecklistItem]
    var filterOptionRawValue: Int
    var sortOptionRawValue: Int

    var filterOption: FilterOption {
        get { FilterOption(rawValue: filterOptionRawValue) ?? .all }
        set { filterOptionRawValue = newValue.rawValue }
    }

    var sortOption: SortOption {
        get { SortOption(rawValue: sortOptionRawValue) ?? .unsorted }
        set { sortOptionRawValue = newValue.rawValue }
    }

    init(name: String, items: [ChecklistItem] = []) {
        self.id = UUID().uuidString
        self.name = name
        self.items = items
        self.filterOptionRawValue = FilterOption.all.rawValue
        self.sortOptionRawValue = SortOption.unsorted.rawValue
    }

    static var sampleData: [Checklist] {
        [
            Checklist(name: "Morning TEMPLATE", items: [
                ChecklistItem(title: "Wake up"),
                ChecklistItem(title: "Brush Teeth"),
                ChecklistItem(title: "Creatine in Coffee"),
                ChecklistItem(title: "Take Multivitamins"),
                ChecklistItem(title: "Duolingo"),
                ChecklistItem(title: "Drink 1L of water")
            ]),
            Checklist(name: "Afternoon TEMPLATE", items: [
                ChecklistItem(title: "Gym"),
                ChecklistItem(title: "Protein Shake"),
                ChecklistItem(title: "Stretch"),
                ChecklistItem(title: "Band over Backs"),
                ChecklistItem(title: "Drink 1L of water"),
                ChecklistItem(title: "Super Juice")
            ])
        ]
    }
}

// Find the existing ChecklistItem class and add the completionDate property:
@Model
class ChecklistItem {
    @Attribute(.unique) var id: String
    var title: String
    var isCompleted: Bool
    var completionDate: Date?    // Add this new property
    
    init(title: String, isCompleted: Bool = false) {
        self.id = UUID().uuidString
        self.title = title
        self.isCompleted = isCompleted
        self.completionDate = isCompleted ? Date() : nil
    }
}



enum FilterOption: Int, CaseIterable {
    case all = 0
    case incomplete = 1
    case completed = 2
    case completedAtBottom = 3

    var description: String {
        switch self {
        case .all: return "All"
        case .incomplete: return "Incomplete"
        case .completed: return "Completed"
        case .completedAtBottom: return "Completed at bottom"
        }
    }
}

enum SortOption: Int, CaseIterable {
    case unsorted = 0
    case alphabetical = 1

    var description: String {
        switch self {
        case .unsorted: return "Unsorted"
        case .alphabetical: return "Alphabetical"
        }
    }
}
