import OpenAI
import SwiftUI

struct BottomBar: View {
	@State private var query = ""
	@State private var model: Model = .gpt4
	@State private var createMethod: Method? = nil
	@State private var cameraManager = CameraManager()
	@State private var photosManager = PhotosManager()

	@State private var keyboardShowing = false
	@FocusState private var queryFocused: Bool

	var showingSheetBinding: Binding<Bool> {
		Binding(get: { createMethod.usesSheet }, set: { _ in createMethod = nil })
	}

	var queryBinding: Binding<String> {
		Binding(
			get: { query },
			set: { value in
				if value.contains("\n") {
					return create()
				}

				query = value
			}
		)
	}

	var body: some View {
		ZStack {
			BottomSheet(show: showingSheetBinding, onClose: { model = .gpt4 }, header: { sheetHeader }, background: { createMethod.sheetBackground }, content: { createMethod.sheetContent })
				.environment(cameraManager)
				.environment(photosManager)

			VStack(spacing: 25) {
				Spacer()

				ZStack(alignment: .bottom) {
					Text("How can I help you?")
						.foregroundStyle(Color.secondaryLabel)
						.offset(y: createMethod.usesSheet ? -100 : 0)
						.animation(.bouncy(duration: 0.4), value: createMethod.usesSheet)
						.opacity(createMethod.usesSheet ? 0 : 1)
						.animation(.smooth(duration: 0.1), value: createMethod.usesSheet)
						.onTapGesture { switchTo(.keyboard) }

					queryField
				}

				HStack {
					ForEach(Method.allCases) { method in
						Button(action: { switchTo(method) }) {
							method.icon(selected: createMethod)
						}
						.transition(.opacity)
						.animation(.smooth(duration: 0.2), value: createMethod)
						.frame(width: 30)

						if !method.isLast {
							Spacer()
						}
					}
				}
				.font(.title2)
				.padding(.horizontal)
				.padding(.bottom, keyboardShowing ? 16 : 0)
				.foregroundStyle(.primary)
			}
			.padding(.horizontal)
		}
		.onKeyboardChange {
			keyboardShowing = $0

			if keyboardShowing && createMethod != .keyboard {
				withAnimation { createMethod = nil }
			}
		}
		.task { photosManager.fetchAllPhotos() }
		.task { cameraManager.startOnBackground() }
	}

	var queryField: some View {
		TextField(text: queryBinding, axis: .vertical) {
			Text("How can I help you?")
				.foregroundStyle(Color.secondaryLabel)
		}
		.animation(.bouncy(duration: 0.2)) {
			$0.offset(x: createMethod == .keyboard ? 0 : 70)
		}
		.padding(8)
		.background(.bar)
		.focused($queryFocused)
		.clipShape(RoundedRectangle(cornerRadius: 10))
		.lineLimit(1...10)
		.submitLabel(.send)
		.onSubmit { create() }
		.animation(.smooth(duration: 0.2)) {
			$0.opacity(createMethod == .keyboard ? 1 : 0)
		}
		.onChange(of: $queryFocused.wrappedValue) { _, queryFocused in
			if queryFocused {
				withAnimation { createMethod = .keyboard }
			} else if createMethod == .keyboard {
				withAnimation { createMethod = nil }
			}
		}
	}

	var sheetHeader: some View {
		VStack(alignment: .leading, spacing: 6) {
			Text("New Thread")
				.font(.headline)

			Menu {
				Picker(selection: $model, label: Text("Select Model")) {
					Label("GPT-4", systemImage: "sparkles").tag(Model.gpt4)
					Label("GPT-3.5", systemImage: "bolt.fill").tag(Model.gpt3_5Turbo)
				}

			} label: {
				HStack {
					Text("ChatGPT")
						.font(.subheadline.bold())
						.foregroundStyle(.primary)

					HStack(spacing: 4) {
						Text(model == .gpt4 ? "4" : "3")
							.font(.subheadline.bold())
							.contentTransition(.numericText())
							.animation(.bouncy, value: model)

						Image(systemName: "chevron.right")
							.font(.caption2.bold())
					}
					// using `Color.secondary` directly here makes it transparent during the camera view (???), somehow `UIColor.secondaryLabel` works
					.foregroundStyle(Color(uiColor: .secondaryLabel))
				}
			}
			.menuOrder(.priority)
			.foregroundStyle(.primary)
		}
	}

	func create() {
		createMethod.create(query)

		withAnimation { createMethod = nil }

		query = ""
		hideKeyboard()
	}

	func switchTo(_ method: Method) {
		query = ""

		withAnimation {
			createMethod = createMethod == method ? nil : method
		}

		if createMethod == .keyboard {
			queryFocused = true
		} else {
			hideKeyboard()
		}
	}
}

#Preview {
	BottomBar()
}
