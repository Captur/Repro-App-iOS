import Foundation
import SwiftUI

struct GuidanceView: View {
    @EnvironmentObject var verificationViewModel: VerificationViewModel

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(Color.blue)
            
            VStack(alignment: .leading) {
                Text(verificationViewModel.guidanceTitle)
                    .foregroundColor(Color.black.opacity(0.7))
                    .bold()
                
                Text(verificationViewModel.guidanceDetail)
                    .foregroundColor(Color.black.opacity(0.7))
                    .lineLimit(10)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
    }
}
