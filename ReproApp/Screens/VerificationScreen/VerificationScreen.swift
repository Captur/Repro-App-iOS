import SwiftUI

struct VerificationScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var homeViewModel: HomeViewModel
    @StateObject var verificationViewModel: VerificationViewModel
    
    init(reference: String) {
        _verificationViewModel = StateObject(wrappedValue: VerificationViewModel(reference: reference))
    }
    
    var body: some View {
        ZStack {
            switch verificationViewModel.verificationState {
            case .camera:
                CameraScreen()
                    .environmentObject(verificationViewModel)
                
            case .feedback:
                FeedbackScreen()
                    .environmentObject(verificationViewModel)
            }
        }
        .onReceive(verificationViewModel.didSendViewDismissRequest, perform: { _ in
            homeViewModel.reset()
            presentationMode.wrappedValue.dismiss()
        })
    }
}
