import SwiftUI

/// Identical to `ButtonStyle` but without the default tap animation
struct FlatButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.contentShape(Rectangle())
	}
}
