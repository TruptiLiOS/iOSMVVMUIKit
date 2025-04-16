import Foundation

enum CarouselCategory: Int, CaseIterable {
    case animal, flower, waterfall

    var imageName: String {
        switch self {
        case .animal: return "animals3"
        case .flower: return "a"
        case .waterfall: return "water1"
        }
    }

    var listItemsImageNames: [String] {
        switch self {
        case .animal: return ["animals1", "animals2", "animals3","animals4", "animals5", "animals6","animals7", "animals1", "animals2","animals3", "animals4", "animals5", "animals6","animals7",  "animals1","animals2", "animals3","animals4"]
        case .flower: return ["a", "b", "c","d","e","f"]
        case .waterfall: return ["water1", "water2", "water3", "water4"]
        }
    }

    var listItemsSubTitle: [String] {
        switch self {
        case .animal: return ["as", "er", "yut","ut", "dfg", "iop","qwe", "rty", "sdf","qwe", "xcvx", "WER","SE", "aD", "asd","Lion", "ERT", "xcv"]
        case .flower: return ["wer", "wer", "ty"]
        case .waterfall: return ["wer", "rty", "oip wer"]
        }
    }

    
    
    var listItems: [String] {
        switch self {
        case .animal: return ["Lion", "Tiger", "Elephant","Lion", "Tiger", "Elephant","Lion", "Tiger", "Elephant","Lion", "Tiger", "Elephant","Lion", "Tiger", "Elephant","Lion", "Tiger", "Elephant"]
        case .flower: return ["Rose", "Lily", "Tulip"]
        case .waterfall: return ["Niagara", "Iguazu", "Angel Falls"]
        }
    }
}

class AnimalViewModel {
    var selectedCategory: CarouselCategory = .animal {
        didSet { onUpdate?() }
    }

    var onUpdate: (() -> Void)?

    var allCategories: [CarouselCategory] {
        CarouselCategory.allCases
    }

    var currentList: [String] {
        if searchQuery.isEmpty {
            return selectedCategory.listItems
        } else {
            return filteredList
        }
    }
    
    var filteredList: [String] = [] {
        didSet { onUpdate?() }
    }

    var searchQuery: String = "" {
        didSet {
            filterList()
        }
    }

    enum Category: CaseIterable {
        case animal, flower, waterfall
    }

    private func filterList() {
        filteredList = selectedCategory.listItems.filter { item in
            item.lowercased().contains(searchQuery.lowercased())
        }
    }

    init() {
        selectedCategory = .animal
        filterList()
    }

}
