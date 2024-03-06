import SwiftUI

struct ThreadRow: View {
	var thread: Thread

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
		}
	}
}

#Preview {
	ThreadRow(thread: Thread.sampleData[0])
		.padding()
		.previewLayout(.sizeThatFits)
}
