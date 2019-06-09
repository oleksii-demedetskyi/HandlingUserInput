import SwiftUI

protocol ConnectedView: View {
    associatedtype State
    associatedtype Props
    associatedtype V: View
    
    func map(state: State, dispatch: @escaping (Action) -> Void) -> Props
    static func body(props: Props) -> V
}

extension ConnectedView {
    func render(state: State, dispatch: @escaping (Action) -> Void) -> V {
        let props = map(state: state, dispatch: dispatch)
        return Self.body(props: props)
    }
    
    var body: StoreConnector<State, V> {
        return StoreConnector(content: render)
    }
}
