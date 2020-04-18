import Foundation
import SwiftUI

struct PlaceCellVM: CellVM, Identifiable {
    var id: Int
    
    var name: String
    var imageName: String = ""
    var placeIconName: String = ""
    var stars: Int
    var ratings: Int
}

extension PlaceCellVM: IdentifiableViewVM {
    var view: some View {
        PlaceRow(viewModel: self)
    }
}
