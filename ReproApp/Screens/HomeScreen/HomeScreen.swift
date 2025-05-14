import Foundation
import SwiftUI

struct HomeScreen: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var showAlert = false
    @State private var showVerificationScreen = false
    @State private var alertMessage = ""
    
    private let hardcodedConfig = ClientConfig.lime_demo_paris_eBike.rawValue
    
    var body: some View {
        VStack(spacing: 16) {
            if homeViewModel.isLoading {
                LoaderView()
            } else {
                Spacer()
                
                switch homeViewModel.rideState {
                case .startRide:
                    Text("Start your ride! Always fetch, load and initialize the model at the start of the ride.")
                        .multilineTextAlignment(.center)
                    
                    Button("Start Ride") {
                        homeViewModel.startRide(selectedConfig: hardcodedConfig)
                    }
                    .padding(.top)
                    
                case .endRide:
                    Text("End ride! Always fetch your client-specific configs before ending the ride.")
                        .multilineTextAlignment(.center)
                    
                    Button("End Ride") {
                        homeViewModel.endRide()
                    }
                    .padding(.top)
                }
                
                Spacer()
            }
        }
        .padding()
        .onReceive(homeViewModel.didSendPresentAlertRequest) { message in
            alertMessage = message
            showAlert = true
        }
        .onReceive(homeViewModel.didSendPresentCameraRequest) { _ in
            showVerificationScreen = true
        }
        .fullScreenCover(isPresented: $showVerificationScreen) {
            VerificationScreen(reference: UUID().uuidString)
                .environmentObject(homeViewModel)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Something went wrong"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
