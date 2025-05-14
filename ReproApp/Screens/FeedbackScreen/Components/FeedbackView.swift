import Foundation
import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject var verificationViewModel: VerificationViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(Color.purple)
            
            VStack(alignment: .leading) {
                Text(verificationViewModel.latestCapturDecision?.reason ?? "Unavailable")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(Color.black)
                    .lineLimit(1)

                Text(verificationViewModel.latestCapturDecision?.decisionTitle ?? "Unavailable")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(Color.black)
                    .lineLimit(1)

                Text(verificationViewModel.latestCapturDecision?.decisionDetail ?? "Unavailable")
                    .font(.system(size: 14))
                    .fontWeight(.regular)
                    .foregroundColor(Color.black.opacity(0.7))
                    .lineLimit(10)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
    }
}
