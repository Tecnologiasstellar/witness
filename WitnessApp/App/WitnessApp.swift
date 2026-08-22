import SwiftUI

@main
struct WitnessApp: App {
    @StateObject private var model = AppModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootTabView(model: model)
                .onChange(of: scenePhase) { _, phase in
                    guard phase == .active else { return }
                    Task.detached {
                        await WitnessSync.shared.drain()
                    }
                }
        }
    }
}
