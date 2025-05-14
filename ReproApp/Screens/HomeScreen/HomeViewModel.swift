import Foundation
import CapturMicromobilityEvents
import AVFoundation
import Combine
import UIKit

let UKLat: Float = 51.509875
let UKLon: Float = -0.118092

class HomeViewModel: ObservableObject {
    @Published var rideState: RideState = .startRide
    @Published var isLoading: Bool = false
    var capturModelInitEngine: CapturModelInitEngine = .cpuAndGpu
    
    private let presentCamera = PassthroughSubject<Void, Never>()
    var didSendPresentCameraRequest: AnyPublisher<Void, Never> {
        presentCamera.eraseToAnyPublisher()
    }
    
    private let presentAlert = PassthroughSubject<String, Never>()
    var didSendPresentAlertRequest: AnyPublisher<String, Never> {
        presentAlert.eraseToAnyPublisher()
    }
    
    var config: ClientConfig!
        
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        observeAppLifecycleNotifications()
    }
    
    private func observeAppLifecycleNotifications() {
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                self?.appMovedToBackground()
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.appMovedToForeground()
            }
            .store(in: &cancellables)
    }

    private func appMovedToBackground() {
        print("App moved to background")
        self.capturModelInitEngine = .cpu
    }

    private func appMovedToForeground() {
        print("App moved to foreground")
        self.capturModelInitEngine = .cpuAndGpu
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
        
    func startRide(selectedConfig: String) {
        if selectedConfig == ClientConfig.lime_demo_paris_eBike.rawValue {
            config = .lime_demo_paris_eBike
        }
        
        try? Captur.shared.setApi(key: config.apiKey)
        print("Demo - api key is set to \(config.rawValue) and api key is \(config.apiKey) and asset is \(config.assetType)")
        
        try? Captur.shared.setDelay(value: 2)
        
        isLoading = true
                
        Captur.shared.prepareModel(locationName: config.locationName, assetType: config.assetType, latitude: nil, longitude: nil) { status, capturError in
            
            DispatchQueue.main.async { self.isLoading = false }
            
            if let error = capturError {
                DispatchQueue.main.async { self.presentAlert.send(error.errorMessage) }
                return
            }
            
            if status {
                DispatchQueue.main.async { self.rideState = .endRide }
                
                DispatchQueue.global(qos: .background).async {
                    do {
                        let etag = try Captur.shared.getEtag()
                        print("[Captur - App] Received Etag: \(etag)")
                    } catch let error as CapturError {
                        if error.errorType == .modelUnavailable {
                            print("[Captur - App] Model has not been initialised: ", error.errorMessage)
                        } else {
                            print("[Captur - App] Unexpected error returning etag: ", error.localizedDescription)
                        }
                    } catch {
                        print("[Captur - App] Unexpected error: ", error.localizedDescription)
                    }
                }
            }
        }
    }
        
    func endRide() {
        isLoading = true
        
 
        Captur.shared.getConfig(locationName: config.locationName, assetType: config.assetType, latitude: 0, longitude: 0) { status, capturError in
            
            DispatchQueue.main.async { self.isLoading = false }
            
            if let error = capturError {
                DispatchQueue.main.async { self.presentAlert.send(error.errorMessage) }
                return
            }
            
            if status {
                self.checkCameraAuthorization()
            }
        }
    }
    
    func reset() {
        DispatchQueue.main.async { self.rideState = .startRide }
    }
    
    private func checkCameraAuthorization() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            self.startVerification()

        case .notDetermined:
            requestCameraAccess()
            
        case .denied, .restricted:
            DispatchQueue.main.async { self.presentAlert.send("Camera access has been denied") }

        @unknown default:
            fatalError("Unknown case in AVCaptureDevice authorizationStatus")
        }
    }
    
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                self.startVerification()
                
            } else {
                DispatchQueue.main.async { self.presentAlert.send("Camera access has been denied") }
            }
        }
    }
    
    private func startVerification() {
        DispatchQueue.main.async { self.presentCamera.send() }
    }
}

enum RideState {
    case startRide
    case endRide
}

enum ClientConfig: String {
    case lime_demo_paris_eBike = "Lime Staging France Paris eBike"

        
    var apiKey: String {
        switch self {
        case .lime_demo_paris_eBike:
            return "captur-workspace-64180c7d1f8075decad93cd9.500c87e4-267a-48c0-8310-cf606599040a"
        }
    }
    
    var locationName: String {
        switch self {
        case .lime_demo_paris_eBike:
            return "Paris"
        }
    }
    
    var assetType: CapturAssetType {
        switch self {
        case .lime_demo_paris_eBike:
            return .eBike
        }
    }
}
