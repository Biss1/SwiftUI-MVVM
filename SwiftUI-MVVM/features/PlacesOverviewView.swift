import SwiftUI

struct PlacesOverviewView: View {
    @ObservedObject var viewModel: PlacesOverviewVM
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.tableViewModel, content: PlaceSection.init(viewModel:))
            }.listStyle(GroupedListStyle())
                
                .navigationBarTitle(viewModel.headerTitle)
                .navigationBarItems(trailing:
                    Button(action: {
                        print("Change category button pressed...")
                        self.viewModel.switchGroupingType()
                    }) {
                        Text("Category")
                    })
        }
    }
}

struct PlaceSection: View {
    var viewModel: TableSectionVM
    
    var body: some View {
        Section(header: BaseHeader(viewModel: viewModel.headerVM as! BaseHeaderVM)) {
//            listView()
            ForEach(viewModel.cellData as! [IdentifiableViewVM]) { viewModel in
                viewModel.view
            }
        }
    }
    
    func listView() -> some View {
        if let cellData = viewModel.cellData as? [PlaceImageCellVM] {
            return AnyView(ForEach(cellData, content: PlaceImageRow.init(viewModel:)))
        } else if let cellData = viewModel.cellData as? [PlaceCellVM] {
            return AnyView(ForEach(cellData, content: PlaceRow.init(viewModel:)))
        }
        return AnyView(Text("no data"))
    }
}

struct BaseHeader: View {
    let viewModel: BaseHeaderVM
    
    var body: some View {
        Text(viewModel.title)
            .font(.system(size: 22))
    }
}

struct PlaceRow: View {
    let viewModel: PlaceCellVM
    
    var body: some View {
        HStack {
            Image(viewModel.imageName)
                .resizable()
                .frame(width: 70.0, height: 70.0)
            Text(viewModel.name)
            VStack(alignment: .trailing, content: {
                Image(viewModel.placeIconName)
                    .resizable()
                    .frame(width: 30.0, height: 30.0)
            })
        }
    }
}

struct PlaceImageRow: View {
    let viewModel: PlaceImageCellVM
    
    var body: some View {
        return ZStack (alignment: .bottomLeading, content: {
            Image(viewModel.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .shadow(radius: 2)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .foregroundColor(.white)
                    .font(.system(size: 22))
                Text(viewModel.name)
                    .foregroundColor(.white)
            }.padding(20)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: nil, alignment: .bottomLeading)
                .background(Color.black.opacity(0.5))
        })
        //                    .sheet(isPresented: missionDetails, onDismiss: {
        //                    self.interaction.missionDetailsDismissed()
        //                }) {
        //                    MissionDetailsView().environmentObject(dependency.store)
        //                }
    }
}

struct PlacesOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesOverviewView(viewModel: PlacesOverviewVM())
    }
}
