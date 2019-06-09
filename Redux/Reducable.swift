protocol Reducable {}


@dynamicMemberLookup
struct ReducableWrapper<State> {
    subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> ReducableWrapper<Value> {
        return ReducableWrapper<Value>()
    }
    
    func with(reducer: @escaping Reducer<State>) -> Reducer<State> {
        return reducer
    }
    
    func withInout(reducer: @escaping InoutReducer<State>) -> Reducer<State> {
        return { state, action in
            var state = state
            reducer(&state, action)
            return state
        }
    }
    
    var withConstant: Reducer<State> {
        return { state, action in state }
    }
    
    func withRules(mathes: @escaping (inout Reduce.Match<State>) -> Void) -> Reducer<State> {
        return { state, action in
            var match = Reduce.Match(action: action, state: state)
            mathes(&match)
            return match.state
        }
    }
}

extension Reducable {
    static var reduce: ReducableWrapper<Self> { ReducableWrapper() }
}
