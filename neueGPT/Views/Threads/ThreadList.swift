import SwiftUI

struct ThreadList: View {
	var threads: [Thread]

	@State private var scrollProgress: CGFloat = 0

	var body: some View {
		ProgressAwareScrollView(progress: $scrollProgress) {
			LazyVStack(spacing: 25) {
				ForEach(threads.groupedByRecency, id: \.0) { period, threads in
					if period != "Today" {
						Text(period)
							.foregroundStyle(.secondary)
							.font(.footnote.bold())
					}

					ForEach(threads) { thread in
						ThreadRow(thread: thread)
					}
				}
			}
			.safeAreaPadding(.horizontal)
		}
		.overlay(bottomShadow)
		.safeAreaPadding(.top, 5)
	}

	var bottomShadow: some View {
		VStack {
			Spacer()

			Rectangle()
				.fill(.linearGradient(colors: [.background.opacity(0), .background.opacity(0.7), .background], startPoint: .top, endPoint: .bottom))
				.offset(y: 10)
				.frame(height: 50)
				.opacity(scrollProgress < 0.99999 ? 1 : 0)
				.animation(.default, value: scrollProgress)
		}
	}
}

#Preview {
	NavigationStack {
		ThreadList(threads: Thread.sampleData)
	}
}
