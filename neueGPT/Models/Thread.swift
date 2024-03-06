import OpenAI
import Foundation

typealias Message = ChatQuery.ChatCompletionMessageParam

struct Thread: Identifiable {
	var id: UUID
	var icon: String
	var title: String
	var createdAt: Date
	var messages: [Message]

	init(id: UUID = UUID(), title: String, icon: String, createdAt: Date = Date(), messages: [Message] = []) {
		self.id = id
		self.icon = icon
		self.title = title
		self.messages = messages
		self.createdAt = createdAt
	}
}

private var timeFormatter: RelativeDateTimeFormatter {
	let formatter = RelativeDateTimeFormatter()
	formatter.unitsStyle = .full
	formatter.dateTimeStyle = .named
	formatter.formattingContext = .beginningOfSentence

	return formatter
}

extension [Thread] {
	var groupedByRecency: [(String, [Thread])] {
		let grouped = Dictionary(grouping: sorted { $0.createdAt > $1.createdAt }) { thread in
			with(timeFormatter.localizedString(for: thread.createdAt.startOfDay, relativeTo: Date().startOfDay)) {
				$0.lowercased() == "now" ? "Today" : $0
			}
		}

		return grouped.sorted { $0.value.first!.createdAt > $1.value.first!.createdAt }
	}
}

extension Thread {
	static var sampleData: [Thread] {
		[
			// Today
			Thread(title: "Mastering French Cuisine: Recipes and Techniques", icon: "cooktop.fill"),
			Thread(title: "Understanding Quantum Computing: Basics and Beyond", icon: "laptopcomputer"),

			// Yesterday
			Thread(title: "Travel Tips: Exploring Japan on a Budget", icon: "airplane", createdAt: Date.yesterday),
			Thread(title: "Mental Health Support: Coping with Anxiety", icon: "heart.circle.fill", createdAt: Date.yesterday),

			// 3 days ago
			Thread(title: "Childcare Tips: Positive Parenting Strategies", icon: "figure.and.child.holdinghands", createdAt: Date.timeAgo(days: 3)),
			Thread(title: "Exploring Space: A Discussion on Mars Colonization", icon: "moonphase.waxing.crescent", createdAt: Date.timeAgo(days: 3)),

			// 4 days ago
			Thread(title: "Music Theory: Composing your First Song", icon: "music.note", createdAt: Date.timeAgo(days: 4)),

			// 5 days ago
			Thread(title: "Global Warming: Understanding Climate Change", icon: "sun.max.fill", createdAt: Date.timeAgo(days: 5)),
			Thread(title: "DIY Projects: Crafting with Recycled Materials", icon: "paintbrush.pointed.fill", createdAt: Date.timeAgo(days: 5)),

			// a week ago
			Thread(title: "Home Gardening: Growing your Own Vegetables", icon: "leaf.fill", createdAt: Date.timeAgo(weeks: 1)),
			Thread(title: "Photography 101: Capturing the Perfect Shot", icon: "camera.fill", createdAt: Date.timeAgo(weeks: 1)),
			Thread(title: "Book Club: Discussing Modern Literature", icon: "book.closed.fill", createdAt: Date.timeAgo(weeks: 1)),
			Thread(title: "Historical Debate: The Impact of the Renaissance", icon: "paintpalette.fill", createdAt: Date.timeAgo(weeks: 1)),

			// a month ago
			Thread(title: "Debating AI Ethics and Future Regulations", icon: "book.fill", createdAt: Date.timeAgo(months: 1)),
			Thread(title: "Travel Tips: Planning Your Adventure in Japan", icon: "airplane", createdAt: Date.timeAgo(months: 1)),
			Thread(title: "Career Advice: Navigating the Tech Industry", icon: "laptopcomputer", createdAt: Date.timeAgo(months: 1)),
			Thread(title: "Movie Recommendations: Finding Hidden Gems", icon: "play.rectangle.fill", createdAt: Date.timeAgo(months: 1)),
			Thread(title: "Fitness Fundamentals: Building a Personal Workout Plan", icon: "figure.run", createdAt: Date.timeAgo(months: 1)),
		]
	}
}
