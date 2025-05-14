import Foundation

internal import DatadogCore
internal import DatadogCrashReporting
internal import DatadogRUM

final class CapturSessionDelegate: NSObject, URLSessionDataDelegate {}


internal class DDInitializerClone {
    let capturInstance = "instance-name"
    private static var core: DatadogCoreProtocol?
    func initialize() {
        if DDInitializerClone.core != nil { return }
        
        let service = capturInstance + getSDKVersion() + "-" + getClientAppName()
        
        DDInitializerClone.core = Datadog.initialize(
            with: .init(
                clientToken: "clienttoken",
                env: "production",
                site: .eu1,
                service: service),
            trackingConsent: .granted,
            instanceName: "instance-name"
        )
        
        
        let traceHosts = Set(["endpoint1", "endpoint2"])

        
        RUM.enable(
            with: RUM.Configuration(
                applicationID: "applicationid",
                uiKitViewsPredicate: DefaultUIKitRUMViewsPredicate(),
                uiKitActionsPredicate: DefaultUIKitRUMActionsPredicate(),
                urlSessionTracking: RUM.Configuration.URLSessionTracking(firstPartyHostsTracing: .trace(hosts: traceHosts)),
                appHangThreshold: 0.25,
                trackWatchdogTerminations: true
            ),
            in: DDInitializerClone.core!
        )

    


        URLSessionInstrumentation.enable(
            with: .init(
                delegateClass: CapturSessionDelegate.self
            ),
            in: DDInitializerClone.core!
        )
        
        CrashReporting.enable(in: DDInitializerClone.core!)
        

        
        #if DEBUG
        Datadog.verbosityLevel = .debug
        #endif
    }
    
    private func getClientAppName() -> String {
        if let appBundle = Bundle.allBundles.first(where: { $0.bundlePath.hasSuffix(".app") }),
           let appName = appBundle.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return appName
        }
        return "unknown"
    }
    
    private func getSDKVersion() -> String {
        
        return "2.8.0"
    }
}
