import Foundation
import SwiftUI

struct CaptureButtonView: View {
    @EnvironmentObject var verificationViewModel: VerificationViewModel
    
    var body: some View {
        Button(action: {
            verificationViewModel.endAttempt()
        }) {
            Circle()
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .padding()
        }
    }
}
