import SwiftUI
import RevenueCat
import GoogleSignIn

@main
struct CueApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var store = SkinStore()

    init() {
        Analytics.setup()
        Purchases.configure(withAPIKey: "REVENUECAT_API_KEY")
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: "732726178398-1uvselk60cjjsd8md0n48stqe0t3apmu.apps.googleusercontent.com"
        )
    }

    var body: some Scene {
        WindowGroup {
            AppRootView(store: store)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
