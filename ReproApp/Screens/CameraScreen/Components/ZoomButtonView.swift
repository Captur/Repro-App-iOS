import Foundation
import SwiftUI

struct ZoomButtonView: View {
    @Binding var isZoomedIn: Bool
    
    var body: some View {
        Button {
            withAnimation {
                isZoomedIn.toggle()
            }
        } label: {
            Text(isZoomedIn ? "Zoom out" : "Zoom in")
                .foregroundColor(.white)
        }
    }
}

struct UltraButtonView: View {
    @Binding var isUltraWide: Bool
    
    var body: some View {
        Button {
            withAnimation {
                isUltraWide.toggle()
            }
        } label: {
            Text(isUltraWide ? "Wide" : "Normal")
                .foregroundColor(.white)
        }
    }
}
