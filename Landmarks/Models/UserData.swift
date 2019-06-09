/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A model object that stores app data.
*/

import Combine
import SwiftUI

final class UserData: BindableObject {
    let didChange = PassthroughSubject<UserData, Never>()
    
    private(set) var showFavoritesOnly = false {
        didSet {
            didChange.send(self)
        }
    }

    private(set) var landmarks = landmarkData {
        didSet {
            didChange.send(self)
        }
    }
    
    func reduce(action: Action) {
        switch action {
            
        case let action as Actions.ToggleLandmarkFavorite:
            let maybeIndex = landmarks.firstIndex { $0.id == action.id }
            guard let index = maybeIndex else {
                break;
            }
            
            landmarks[index].isFavorite.toggle()
            
        case let action as Actions.ToggleFavoritesOnly:
            showFavoritesOnly = action.shouldShowFavorites
        default: break }
    }
    
    func bind(_ action: Action) -> () -> Void {
        return {
            self.reduce(action: action)
        }
    }

    func binding<T>(of valuePath: KeyPath<UserData, T>, to action: @escaping (T) -> Action) -> Binding<T> {
        return Binding<T>(
            getValue: { self[keyPath: valuePath] },
            setValue: { self.reduce(action: action($0)) }
        )
    }
    
}
