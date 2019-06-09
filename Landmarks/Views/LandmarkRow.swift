/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A single row to be displayed in a list of landmarks.
*/

import SwiftUI

struct LandmarkRow: ConnectedView {
    struct Props {
        let name: String
        let imageName: String
        let isFavorite: Bool
    }
    
    let id: Landmark.ID
    
    func map(state: State, dispatch: @escaping (Action) -> Void) -> Props {
        guard let landmark = state.landmarksByID[id] else {
            fatalError("Id not found")
        }
        
        return Props(name: landmark.name,
              imageName: landmark.imageName,
              isFavorite: landmark.isFavorite)
    }
    
    static func body(props: Props) -> some View {
        HStack {
            ImageStore.shared.image(name: props.imageName, size: 50)
            Text(verbatim: props.name)
            Spacer()
            
            if props.isFavorite {
                Image(systemName: "star.fill")
                    .imageScale(.medium)
                    .foregroundColor(.yellow)
            }
        }
    }
}
