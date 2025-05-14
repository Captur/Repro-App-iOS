import Foundation
import Combine
import CapturMicromobilityEvents

class VerificationViewModel: ObservableObject {
    @Published var verificationState: VerificationState = .camera
    @Published var guidanceTitle: String = ""
    @Published var guidanceDetail: String = ""
    @Published var latestCapturDecision: CapturOutput?
    
    var capturCameraManager: CapturCameraManager?
    var storedReference: String!
    
    private let dismissViewSubject = PassthroughSubject<Void, Never>()
    var didSendViewDismissRequest: AnyPublisher<Void, Never> {
        dismissViewSubject.eraseToAnyPublisher()
    }
    
    private let flashSubject = PassthroughSubject<Bool, Never>()
    var didSendFlashRequest: AnyPublisher<Bool, Never> {
        flashSubject.eraseToAnyPublisher()
    }
    
    init(reference: String) {
        storedReference = reference
        capturCameraManager = CapturCameraManager(referenceId: storedReference)
        capturCameraManager?.subscribeToEvents(events: self)
    }
    
    func endVerification() {
        dismissViewSubject.send()
    }
    
    func retake() {
        capturCameraManager?.retake()
        DispatchQueue.main.async {
            self.guidanceTitle = ""
            self.guidanceDetail = ""
            self.verificationState = .camera
        }
    }
    
    func endAttempt() {
        capturCameraManager?.endAttempt()
    }
}

extension VerificationViewModel: CapturEvents {
    func capturDidGenerateEvent(state: CapturCameraState, metadata: CapturOutput?) {
        switch state {
            
        case .cameraRunning:
            return
            
        case .cameraDecided:
            guard let metadata = metadata else {return}
            DispatchQueue.main.async { self.handleDecision(metadata: metadata) }
            
        @unknown default:
            return
        }
    }
    
    func capturDidGenerateError(error: CapturError) {
        return
    }
    
    func capturDidGenerateGuidance(metadata: CapturOutput) {
        print("Guidance fired .. \(metadata.reason)")
        self.guidanceTitle = metadata.guidanceTitle ?? ""
        self.guidanceDetail = metadata.guidanceDetail ?? ""
        
        if metadata.reason == "too_dark" {
            flashSubject.send(true)
        }
    }
    
    func capturDidRevokeGuidance() {
        return
    }
    
    private func handleDecision(metadata: CapturOutput) {
        self.latestCapturDecision = metadata
        self.verificationState = .feedback
    }
}

enum VerificationState {
    case camera
    case feedback
}
