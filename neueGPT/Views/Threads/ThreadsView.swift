import SwiftUI
import SwiftUIIntrospect

struct ThreadsView: View {
	var body: some View {
		ZStack {
			VStack {
				ThreadList(threads: Thread.sampleData)

				Spacer(minLength: 80)
			}

			BottomThreadCreator()
		}
		.navigationTitle("Chats")
	}
}

#Preview {
	NavigationStack {
		ThreadsView()
	}
}
