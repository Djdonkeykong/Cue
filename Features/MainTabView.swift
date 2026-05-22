import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Scan", systemImage: "camera.viewfinder", value: 0) {
                NavigationStack {
                    ScannerRootView()
                }
            }
            Tab("Tracker", systemImage: "chart.dots.scatter", value: 1) {
                NavigationStack {
                    TrackerRootView()
                }
            }
            Tab("Insights", systemImage: "sparkles", value: 2) {
                NavigationStack {
                    InsightsRootView()
                }
            }
            Tab("Profile", systemImage: "person.circle", value: 3) {
                NavigationStack {
                    ProfileRootView()
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}
