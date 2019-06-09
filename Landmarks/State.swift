struct State: Reducable {
    let landmarksByID: [Landmark.ID: Landmark]
    let allLandmarks: [Landmark.ID]
    let showFavoritesOnly: Bool
}

extension Reduce {
    static let state = State.reduce.with { state, action in
        State(
            landmarksByID: Reduce.landmarksByID(state.landmarksByID, action),
            allLandmarks: Reduce.allLendmarks(state.allLandmarks, action),
            showFavoritesOnly: Reduce.showFavoritesOnly(state.showFavoritesOnly, action)
        )
    }
    
    static let landmarksByID = State.reduce.landmarksByID.withRules { match in
        match.on(Actions.ToggleLandmarkFavorite.self) { state, action in
            state[action.id]?.isFavorite.toggle()
        }
    }
    
    static let allLendmarks = State.reduce.allLandmarks.withConstant
    
    static let showFavoritesOnly = State.reduce.showFavoritesOnly.withRules { match in
        match.on(Actions.ToggleFavoritesOnly.self) { state, action in
            action.shouldShowFavorites
        }
    }
}
