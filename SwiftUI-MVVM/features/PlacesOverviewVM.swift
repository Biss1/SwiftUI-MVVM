import Foundation
import Combine

class PlacesOverviewVM: ObservableObject {
    @Published var headerTitle: String = "Places"
    @Published var tableViewModel: [TableSectionVM] = []

    var groupingType: PlacesGroupingType = .byCategory

    init() {
        setupList()
    }
    
    func setupList() {
        switch groupingType {
        case .byCategory:
            tableViewModel = placesGroupedByCategory()
        case .byCountry:
            tableViewModel = placesGroupedByCountry()
        }
    }
    
    func switchGroupingType() {
        groupingType = groupingType == .byCategory ? .byCountry: .byCategory
        setupList()
    }

    func placesGroupedByCategory() -> [TableSectionVM] {
        let visitedPlacesIds = DataService.visitedPlacesIds
        let placesGrouped = Dictionary(grouping: DataService.places, by: { $0.category })
        let places = placesGrouped.mapValues { (places) -> [PlaceImageCellVM] in
            places.map { (place) -> PlaceImageCellVM in
                let visited = visitedPlacesIds.contains(place.id)
                return PlaceImageCellVM(id: place.id,
                                        name: place.name,
                                        imageName: place.image,
                                        showVisitedIcon: visited)
            }
        }
        let sections =  places.map({ (arg) -> TableSectionVM in
            let (placeType, placeCellVMs) = arg
            let headerVM = BaseHeaderVM(title: placeType.description())
            return TableSectionVM(id: placeType.description(), headerVM: headerVM, cellData: placeCellVMs)
        })
        return sections.sorted(by: sortSection)
    }

    func placesGroupedByCountry() -> [TableSectionVM] {
        let placesGrouped = Dictionary(grouping: DataService.places, by: { $0.country })
        let places = placesGrouped.mapValues { (places) -> [PlaceCellVM] in
            places.map { (place) -> PlaceCellVM in
                let ratings = DataService.ratings.filter({ $0.placeId == place.id })
                    .map( {$0.stars })
                return PlaceCellVM(id: place.id,
                                   name: place.name, imageName: place.image,
                                   placeIconName: "icon_" + place.category.rawValue,
                                   stars: Int(ratings.average),
                                   ratings: ratings.count)
            }
        }
        let sections = places.map({ (arg) -> TableSectionVM in
            let (placeCountry, placeCellVMs) = arg
            let headerVM = BaseHeaderVM(title: placeCountry)
            return TableSectionVM(id: placeCountry, headerVM: headerVM, cellData: placeCellVMs)
        })
        return sections.sorted(by: sortSection)
    }

    func sortSection(first: TableSectionVM, second: TableSectionVM) -> Bool {
        return (first.headerVM as! BaseHeaderVM).title < (second.headerVM as! BaseHeaderVM).title
    }
    
    enum PlacesGroupingType {
        case byCategory
        case byCountry
    }
}
