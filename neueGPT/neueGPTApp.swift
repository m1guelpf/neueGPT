import SwiftUI

@main
struct neueGPTApp: App {
	var body: some Scene {
		WindowGroup {
			NavigationStack {
				ThreadsView()
			}
		}
	}
}
