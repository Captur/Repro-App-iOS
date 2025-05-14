import Foundation
import SwiftUI

struct FeedbackScreen: View {
    
    @EnvironmentObject var verificationViewModel: VerificationViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                BackgroundImageView(width: geo.size.width, height: geo.size.height)
                    .environmentObject(verificationViewModel)
                
                VStack(spacing: 16) {
                    VStack(spacing: 0) {
                        FeedbackView()
                            .frame(width: geo.size.width * 0.9)
                            .environmentObject(verificationViewModel)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.top)
                    
                    Spacer()
                    
                    HStack {
                        RetakeButtonView()
                            .environmentObject(verificationViewModel)
                        
                        EndRideButtonView()
                            .environmentObject(verificationViewModel)
                    }
                    .padding()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}
