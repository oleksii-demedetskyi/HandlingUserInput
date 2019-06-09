typealias Reducer<State> = (State, Action) -> State
typealias InoutReducer<State> = (inout State, Action) -> Void

enum Reduce {
    struct Match<State> {
        let action: Action
        var state: State
        
        mutating func on<A: Action>(_ type: A.Type, reduce: @escaping (State, A) -> State) {
            guard let action = action as? A else {
                return
            }
            
            state = reduce(state, action)
        }
        
        mutating func on<A: Action>(_ type: A.Type, reduce: @escaping (inout State, A) -> Void) {
            guard let action = action as? A else {
                return
            }
            
            reduce(&state, action)
        }
    }
}

