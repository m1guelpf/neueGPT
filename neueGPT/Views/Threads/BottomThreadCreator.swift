import OpenAI
import SwiftUI

enum Tab: CaseIterable {
	enum ActionType {
		case send
		case cancel
	}

	case photos
	case camera
	case keyboard
	case transcribe
	case talk

	fileprivate var systemImage: String {
		switch self {
			case .photos:
				return "photo.stack.fill"
			case .camera:
				return "camera.fill"
			case .keyboard:
				return "keyboard.fill"
			case .transcribe:
				return "waveform.badge.mic"
			case .talk:
				return "headphones"
		}
	}

	fileprivate var helpText: String? {
		switch self {
			case .photos:
				return "Select a picture"
			case .camera:
				return nil
			case .keyboard:
				return "Ask your question"
			case .transcribe:
				return "Start dictating"
			case .talk:
				return "Connecting..."
		}
	}

	fileprivate var actionType: ActionType {
		switch self {
			case .photos, .camera, .keyboard, .transcribe:
				return .send
			case .talk:
				return .cancel
		}
	}
}

struct BottomThreadCreator: View {
	@State private var model: Model = .gpt4
	@State private var selectedTab: Tab? = nil

	var isSheetPresented: Binding<Bool> {
		Binding(get: { selectedTab != nil }, set: { _ in selectedTab = nil })
	}

	var body: some View {
		ZStack {
			BottomSheet(show: isSheetPresented, onClose: { model = .gpt4 }, header: { sheetHeader }) {
				if let helpText = selectedTab!.helpText {
					Text(helpText)
						.foregroundStyle(Color.mutedSecondary)
				}
			}

			VStack(spacing: 25) {
				Spacer()

				Text("How can I help you?")
					.foregroundStyle(.secondary)
					.offset(y: selectedTab != nil ? -100 : 0)
					.animation(.bouncy(duration: 0.4), value: selectedTab)
					.opacity(selectedTab != nil ? 0 : 1)
					.animation(.smooth(duration: 0.1), value: selectedTab)

				HStack {
					ForEach(Tab.allCases, id: \.self) { tab in
						Button(action: { openSheet(tab: tab) }) {
							if selectedTab == tab {
								Image(systemName: tab.actionType == .cancel ? "xmark.circle.fill" : "arrow.up.circle.fill")
									.symbolRenderingMode(.hierarchical)
									.foregroundStyle(tab.actionType == .cancel ? .red : Color.accentColor)
									.font(.title)
							} else {
								Image(systemName: tab.systemImage)
							}
						}
						.transition(.opacity)
						.animation(.smooth(duration: 0.2), value: selectedTab)
						.frame(width: 30)

						if tab != .talk {
							Spacer()
						}
					}
				}
				.font(.title2)
				.padding(.horizontal)
				.foregroundStyle(.primary)
			}
			.padding(.horizontal)
		}
	}

	var sheetHeader: some View {
		VStack(alignment: .leading) {
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
					}.foregroundStyle(.secondary)
				}
			}
			.menuOrder(.priority)
			.foregroundStyle(.primary)
		}
	}

	func openSheet(tab: Tab) {
		withAnimation {
			selectedTab = selectedTab == tab ? nil : tab
		}
	}
}

#Preview {
	BottomThreadCreator()
}
