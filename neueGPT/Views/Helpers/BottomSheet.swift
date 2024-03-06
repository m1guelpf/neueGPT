import SwiftUI

struct BottomSheet<Background: View, Header: View, Content: View>: View {
	typealias CloseCallback = () -> Void

	@Binding var show: Bool
	var onClose: CloseCallback?
	var header: () -> Header
	var content: () -> Content
	var background: () -> Background

	@State private var scrollOffset: CGFloat = .zero

	init(
		show: Binding<Bool>,
		onClose: CloseCallback? = nil,
		@ViewBuilder header: @escaping () -> Header,
		@ViewBuilder background: @escaping () -> Background,
		@ViewBuilder content: @escaping () -> Content
	) {
		_show = show
		self.onClose = onClose

		self.header = header
		self.content = content
		self.background = background
	}

	init(
		show: Binding<Bool>,
		onClose: CloseCallback? = nil,
		@ViewBuilder header: @escaping () -> Header,
		@ViewBuilder content: @escaping () -> Content
	) where Background == EmptyView {
		self.init(show: show, onClose: onClose, header: header, background: { EmptyView() }, content: content)
	}

	var dragGesture: some Gesture {
		DragGesture().onChanged { gesture in
			scrollOffset = max(0, gesture.translation.height)
		}.onEnded { gesture in
			if gesture.translation.height > 50 {
				withAnimation { show = false } completion: {
					scrollOffset = .zero
				}
			} else {
				withAnimation(.smooth(duration: 0.25)) {
					scrollOffset = .zero
				}
			}
		}
	}

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
				.background(background())
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
		.offset(y: scrollOffset)
		.animation(.bouncy(duration: 0.4), value: show)
		.ignoresSafeArea(edges: .top)
		.gesture(
			dragGesture
		)
		.onChange(of: show) { prevState, newState in
			if prevState && !newState {
				onClose?()
			}
		}
	}
}

#Preview {
	struct Preview: View {
		@State private var show = true

		var body: some View {
			ZStack {
				BottomSheet(show: $show, header: { Text("Example Sheet") }) {
					Text("content here!")
				}
			}
		}
	}

	return Preview()
}
