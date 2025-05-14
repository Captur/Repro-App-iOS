import Foundation
import SwiftUI

struct ToolbarView: View {
    @State private var isLoading = false
    
    var body: some View {
        HStack {
            Text("Follow instruction to end delivery")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.black)
        }
        .padding()
        .background(Color.white)
        .opacity(0.5)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
