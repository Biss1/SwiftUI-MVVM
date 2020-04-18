import SwiftUI

public struct TableSectionVM: Identifiable {
    public var id: String
    var headerVM: HeaderVM?
    var footerVM: FooterVM?
    var cellData: [CellVM]
}

public protocol HeaderVM {}
public protocol FooterVM {}
public protocol CellVM {}

public struct BaseHeaderVM: HeaderVM {
    var title: String
}

public protocol IdentifiableViewVM {
    var id: Any { get }
    var view: some View { get }
}
