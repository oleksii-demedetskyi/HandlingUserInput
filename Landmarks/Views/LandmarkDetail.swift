/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the details for a landmark.
*/

import SwiftUI
import CoreLocation

struct LandmarkDetail: ConnectedView {
    let id: Landmark.ID
    
    struct Props {
        let location: CLLocationCoordinate2D
        let imageName: String
        let name: String
        let toggleFavorite: () -> Void
        let isFavorite: Bool
        let park: String
        let state: String
    }

    func map(state: State, dispatch: @escaping (Action) -> Void) -> Props {
        guard let landmark = state.landmarksByID[id] else {
            fatalError("Id not found")
        }
        
        return Props(
            location: landmark.locationCoordinate,
            imageName: landmark.imageName,
            name: landmark.name,
            toggleFavorite: { dispatch(Actions.ToggleLandmarkFavorite(id: self.id)) },
            isFavorite: landmark.isFavorite,
            park: landmark.park,
            state: landmark.state)
    }
    
    static func body(props: Props) -> some View {
        VStack {
            MapView(coordinate: props.location)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)
            
            CircleImage(image: ImageStore.shared.image(
                name: props.imageName,
                size: 250))
                .offset(x: 0, y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(verbatim: props.name)
                        .font(.title)
                    
                    Button(action: props.toggleFavorite) {
                        if props.isFavorite {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.yellow)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                
                HStack(alignment: .top) {
                    Text(verbatim: props.park)
                        .font(.subheadline)
                    Spacer()
                    Text(verbatim: props.state)
                        .font(.subheadline)
                }
                }
                .padding()
            
            Spacer()
        }
    }
}
