import Foundation

extension Date {
	var startOfDay: Date {
		return Calendar.current.startOfDay(for: self)
	}

	static var yesterday: Date {
		return timeAgo(days: 1)
	}

	static func timeAgo(_ unit: Calendar.Component, amount: Int) -> Date {
		return Calendar.current.date(byAdding: unit, value: -amount, to: Date()) ?? Date()
	}

	static func timeAgo(days: Int) -> Date {
		return timeAgo(.day, amount: days)
	}

	static func timeAgo(weeks: Int) -> Date {
		return timeAgo(.weekOfYear, amount: weeks)
	}

	static func timeAgo(months: Int) -> Date {
		return timeAgo(.month, amount: months)
	}
}
