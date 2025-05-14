import Foundation
import SwiftUI

struct EndRideButtonView: View {
    @EnvironmentObject var verificationViewModel: VerificationViewModel
    
    var body: some View {
        Button(action: {
            verificationViewModel.endVerification()
        }) {
            Text("End ride")
                .fontWeight(.medium)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black.opacity(0.7), lineWidth: 1.5)
                )
        }
    }
}
