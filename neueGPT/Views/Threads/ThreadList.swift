import SwiftUI

struct ThreadList: View {
	var threads: [Thread]

	@State private var searchText: String = ""
	@State private var scrollProgress: CGFloat = 0

	var filteredThreads: [Thread] {
		if searchText.isEmpty {
			return threads
		} else {
			return threads.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
		}
	}

	var body: some View {
		ProgressAwareScrollView(progress: $scrollProgress) {
			LazyVStack(spacing: 40) {
				ForEach(filteredThreads) { item in
					ThreadRow(thread: item)
				}
			}
			.safeAreaPadding(.horizontal)
		}
		.overlay {
			VStack {
				Spacer()

				Rectangle()
					.fill(.linearGradient(colors: [.background.opacity(0), .background.opacity(0.7), .background], startPoint: .top, endPoint: .bottom))
					.opacity(scrollProgress < 0.99 ? 1 : 0)
					.animation(.default, value: scrollProgress)
					.frame(height: 50)
					.offset(y: 10)
			}
		}
		.searchable(text: $searchText)
	}
}

#Preview {
	NavigationStack {
		ThreadList(threads: Thread.sampleData)
	}
}
