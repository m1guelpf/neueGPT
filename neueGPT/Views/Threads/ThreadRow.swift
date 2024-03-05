import SwiftUI

struct ThreadRow: View {
	var thread: Thread

	@State private var totalWidth: CGFloat = 0

	var body: some View {
		HStack {
			VStack {
				Image(systemName: thread.icon)
			}.font(.title2).frame(maxWidth: 40)

			Spacer(minLength: 20)

			Text(thread.title)
				.lineLimit(2)
				.font(.title3.weight(.medium))
				.lineSpacing(6)
				.multilineTextAlignment(.leading)
				.frame(maxWidth: .infinity, alignment: .leading)

			Spacer(minLength: 20)

			Image(systemName: "chevron.right")
				.foregroundStyle(.secondary)
				.font(.callout)
		}.overlay {
			GeometryReader { geometry in
				Color.clear.onAppear {
					totalWidth = geometry.size.width
				}
			}
		}
	}
}

#Preview {
	ThreadRow(thread: Thread.sampleData[0])
		.padding()
		.previewLayout(.sizeThatFits)
}
