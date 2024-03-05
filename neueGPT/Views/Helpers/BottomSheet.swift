import SwiftUI

struct BottomSheet<Header: View, Content: View>: View {
	typealias CloseCallback = () -> Void

	@Binding var show: Bool
	var onClose: CloseCallback?
	@ViewBuilder var header: () -> Header
	@ViewBuilder var content: () -> Content

	var body: some View {
		VStack(spacing: 100) {
			Color.clear

			if show {
				VStack {
					HStack(alignment: .top) {
						VStack {
							header()
						}

						Spacer()

						Button(action: { withAnimation { show = false } }) {
							Image(systemName: "xmark")
						}
						.bold()
						.offset(y: 2)
						.foregroundStyle(.primary)
					}

					Spacer()

					VStack {
						content()
					}

					Spacer()

					Color.clear.frame(height: 10)
				}
				.padding(20)
				.background(.thickMaterial.shadow(.drop(color: .black.opacity(0.4), radius: 20, x: 0, y: -10)))
				.overlay {
					GeometryReader { geometry in
						Rectangle()
							.fill(.thickMaterial)
							.offset(y: geometry.size.height + geometry.safeAreaInsets.bottom)
					}
				}
				.transition(.move(edge: .bottom).combined(with: .opacity))
			}
		}
		.animation(.bouncy(duration: 0.4), value: show)
		.ignoresSafeArea(edges: .top)
		.onChange(of: show) { prevState, newState in
			if prevState && !newState {
				onClose?()
			}
		}
	}
}

#Preview {
	ZStack {
		BottomSheet(show: .constant(true), header: { Text("Example Sheet") }) {
			Text("content here!")
		}
	}
}
