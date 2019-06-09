import SwiftUI

struct StoreProvider<S, V: View>: View {
    let store: Store<S>
    let content: () -> V
    
    var body: some View {
        content().environmentObject(store)
    }
}
