import Foundation
import SwiftUI

struct FlashButtonView: View {
    @Binding var isFlashOn: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(isFlashOn ? Color.yellow : Color.white)
            
            Image(systemName: "flashlight.on.fill")
                .foregroundColor(Color.black)
                .font(.system(size: 20))
        }
        .onTapGesture {
            withAnimation {
                isFlashOn.toggle()
            }
        }
    }
}
