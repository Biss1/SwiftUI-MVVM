import Foundation
import SwiftUI

struct PlaceImageCellVM: CellVM, Identifiable {
    var id: Int
    
    var name: String
    var imageName: String
    var showVisitedIcon: Bool
}

extension PlaceImageCellVM: IdentifiableViewVM {
    var view: some View {
        PlaceImageRow(viewModel: self)
    }
}
