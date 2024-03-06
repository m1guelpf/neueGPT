import SwiftUI
import SwiftUIIntrospect

struct ThreadsView: View {
	@State private var searchText = ""

	let threads = Thread.sampleData
	var filteredThreads: [Thread] {
		if searchText.isEmpty {
			return threads
		} else {
			return threads.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
		}
	}

	var body: some View {
		ZStack {
			VStack {
				ThreadList(threads: filteredThreads)
					.searchable(text: $searchText)

				Spacer(minLength: 80)
			}

			BottomBar()
		}
		.navigationTitle("Chats")
	}
}

#Preview {
	NavigationStack {
		ThreadsView()
	}
}
