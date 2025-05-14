import Foundation
import SwiftUI

struct CloseButtonView: View {
    @EnvironmentObject var verificationViewModel: VerificationViewModel
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.white)
            
            Image(systemName: "xmark")
                .foregroundColor(Color.black)
                .font(.system(size: 20))
        }
        .onTapGesture {
            verificationViewModel.endVerification()
        }
    }
}
