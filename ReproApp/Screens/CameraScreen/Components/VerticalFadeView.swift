import Foundation
import SwiftUI

struct VerticalFadeView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                Gradient.Stop(color: Color.black.opacity(0.9), location: 0),
                Gradient.Stop(color: Color.clear, location: 0.8)
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}
