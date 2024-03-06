import Foundation

/// Call the given Closure with this instance then return the instance.
func tap<T>(_ value: T, _ closure: (T) -> Void) -> T {
	closure(value)
	return value
}

/// Return the given value passed through the given callback.
func with<T, R>(_ value: T, _ closure: (T) -> R) -> R {
	closure(value)
}
