import Foundation
import SwiftUI

struct RetakeButtonView: View {
    @EnvironmentObject var verificationViewModel: VerificationViewModel
    
    var body: some View {
        Button(action: {
            verificationViewModel.retake()
        }) {
            Text("Retake")
                .fontWeight(.medium)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black.opacity(0.7), lineWidth: 1.5)
                )
        }
    }
}
