import SwiftUI
import Combine

extension View {
	fileprivate var keyboardPublisher: AnyPublisher<Bool, Never> {
		Publishers
			.Merge(
				NotificationCenter
					.default
					.publisher(for: UIResponder.keyboardWillShowNotification)
					.map { _ in true },
				NotificationCenter
					.default
					.publisher(for: UIResponder.keyboardWillHideNotification)
					.map { _ in false }
			)
			.debounce(for: .seconds(0.1), scheduler: RunLoop.main)
			.eraseToAnyPublisher()
	}

	/// Subscribe to keyboard presentation changes
	func onKeyboardChange(_ action: @escaping (Bool) -> Void) -> some View {
		onReceive(keyboardPublisher, perform: action)
	}

	/// Quickly dismiss the keyboard
	func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
