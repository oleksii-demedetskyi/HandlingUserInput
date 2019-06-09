/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of landmarks.
*/

import SwiftUI

struct LandmarkList<Row: View, Details: View>: ConnectedView {
    let row: (Landmark.ID) -> Row
    let details: (Landmark.ID) -> Details
    
    struct Props<Row: View, Details: View> {
        let showFavoritesOnly: Binding<Bool>
        let landmarks: [LandmarkItem<Row, Details>]
        
        struct LandmarkItem<Row: View, Details: View>: Identifiable {
            let id: Landmark.ID
            let row: Row
            let details: Details
        }
    }
    
    func map(state: State, dispatch: @escaping (Action) -> Void) -> Props<Row, Details>  {
        let showFavoritesOnly = Binding<Bool>(
            getValue: { state.showFavoritesOnly },
            setValue: { dispatch(Actions.ToggleFavoritesOnly(shouldShowFavorites: $0))}
        )
        
        let allLandmarks = state.allLandmarks.compactMap { id in
            state.landmarksByID[id]
        }
        
        let visibleLandmarks = allLandmarks.filter { landmark in
            if state.showFavoritesOnly {
                return landmark.isFavorite
            } else {
                return true
            }
        }
        
        let landmarkItems = visibleLandmarks.map { landmark in
            LandmarkList.Props.LandmarkItem(
                id: landmark.id,
                row: row(landmark.id),
                details: details(landmark.id))
        }
        
        return Props(
            showFavoritesOnly: showFavoritesOnly,
            landmarks: landmarkItems)
    }
    
    static func body(props: Props<Row, Details>) -> some View {
        NavigationView {
            List {
                Toggle(isOn: props.showFavoritesOnly) {
                    Text("Show Favorites Only")
                }
                
                ForEach(props.landmarks) { landmark in
                    NavigationButton(destination: landmark.details) {
                        landmark.row
                    }
                }
            }.navigationBarTitle(Text("Landmarks"), displayMode: .large)
        }
    }
}
