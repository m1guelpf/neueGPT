import OpenAI
import Foundation

typealias Message = ChatQuery.ChatCompletionMessageParam

struct Thread: Identifiable {
	var id: UUID
	var icon: String
	var title: String
	var messages: [Message]

	init(id: UUID = UUID(), title: String, icon: String, messages: [Message] = []) {
		self.id = id
		self.icon = icon
		self.title = title
		self.messages = messages
	}
}

extension Thread {
	static var sampleData: [Thread] {
		[
			Thread(title: "Understanding Quantum Computing: Basics and Beyond", icon: "laptopcomputer"),
			Thread(title: "Mastering French Cuisine: Recipes and Techniques", icon: "cooktop.fill"),
			Thread(title: "Travel Tips: Exploring Japan on a Budget", icon: "airplane"),
			Thread(title: "Exploring Space: A Discussion on Mars Colonization", icon: "moonphase.waxing.crescent"),
			Thread(title: "Mental Health Support: Coping with Anxiety", icon: "heart.circle.fill"),
			Thread(title: "Childcare Tips: Positive Parenting Strategies", icon: "figure.and.child.holdinghands"),
			Thread(title: "Music Theory: Composing your First Song", icon: "music.note"),
			Thread(title: "Global Warming: Understanding Climate Change", icon: "sun.max.fill"),
			Thread(title: "DIY Projects: Crafting with Recycled Materials", icon: "paintbrush.pointed.fill"),
			Thread(title: "Book Club: Discussing Modern Literature", icon: "book.closed.fill"),
			Thread(title: "Photography 101: Capturing the Perfect Shot", icon: "camera.fill"),
			Thread(title: "Historical Debate: The Impact of the Renaissance", icon: "paintpalette.fill"),
			Thread(title: "Home Gardening: Growing your Own Vegetables", icon: "leaf.fill"),
			Thread(title: "Debating AI Ethics and Future Regulations", icon: "book.fill"),
			Thread(title: "Career Advice: Navigating the Tech Industry", icon: "laptopcomputer"),
			Thread(title: "Movie Recommendations: Finding Hidden Gems", icon: "play.rectangle.fill"),
			Thread(title: "Fitness Fundamentals: Building a Personal Workout Plan", icon: "figure.run"),
			Thread(title: "Travel Tips: Planning Your Adventure in Japan", icon: "airplane"),
		]
	}
}
