import Foundation
import SwiftUI
import CapturMicromobilityEvents

struct CameraScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var verificationViewModel: VerificationViewModel
    @State var isFlashOn: Bool = false
    @State var isZoomedIn: Bool = false
    @State var isUltraWide: Bool = false
    
    init(){
        DDInitializerClone().initialize()
    }
    
    var body: some View {
        ZStack {
            if verificationViewModel.capturCameraManager != nil {
                if isUltraWide {
                    CapturUltraWideCamera(capturCameraHandler: verificationViewModel.capturCameraManager!, isFlashOn: $isFlashOn)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    CapturCamera(capturCameraHandler: verificationViewModel.capturCameraManager!, isFlashOn: $isFlashOn, isZoomedIn: $isZoomedIn)
                        .edgesIgnoringSafeArea(.all)
                }
            }
            
            VerticalFadeView()
            
            VStack {
                if verificationViewModel.guidanceTitle != "" {
                    GuidanceView()
                        .environmentObject(verificationViewModel)
                }
                
                Spacer()
                
                HStack {
                    ZoomButtonView(isZoomedIn: $isZoomedIn)

                    Spacer()
                    
                    UltraButtonView(isUltraWide: $isUltraWide)
                }
                
                HStack {
                    CloseButtonView()
                        .environmentObject(verificationViewModel)
                    
                    Spacer()
                    
                    CaptureButtonView()
                        .environmentObject(verificationViewModel)

                    Spacer()
                    
                    FlashButtonView(isFlashOn: $isFlashOn)
                }
                .padding()
            }
        }
        .background(Color.black)
        .onReceive(verificationViewModel.didSendViewDismissRequest, perform: { _ in
            isFlashOn = false
            presentationMode.wrappedValue.dismiss()
        })
        .onReceive(verificationViewModel.didSendFlashRequest, perform: { _ in
            isFlashOn = true
        })
    }
}
