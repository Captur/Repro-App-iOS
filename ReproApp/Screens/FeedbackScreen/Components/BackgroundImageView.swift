import Foundation
import SwiftUI

struct BackgroundImageView: View {
    @EnvironmentObject var verificationViewModel: VerificationViewModel
    @State var width: CGFloat
    @State var height: CGFloat
    
    var body: some View {
        if verificationViewModel.latestCapturDecision?.image != nil {
            Image(uiImage: verificationViewModel.latestCapturDecision!.image!)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: width, height: height)
        } else {
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(Color.blue)
        }
    }
}
