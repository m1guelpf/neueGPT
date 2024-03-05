import UIKit
import SwiftUI

struct ProgressAwareScrollView<Content: View>: View {
	let axis: Axis.Set
	let showIndicators: Bool
	let content: () -> Content
	@Binding var progress: CGFloat

	init(_ axis: Axis.Set = .vertical, progress: Binding<CGFloat>, showIndicators: Bool = true, content: @escaping () -> Content) {
		self.axis = axis
		_progress = progress
		self.content = content
		self.showIndicators = showIndicators
	}

	var body: some View {
		ScrollView(axis, content: content)
			.introspect(.scrollView, on: .iOS(.v17)) { scrollView in
				guard scrollView.strongDelegate == nil else { return }

				scrollView.strongDelegate = ScrollViewDelegate(parent: self, baseDelegate: scrollView.delegate as? UICollectionViewDelegate)
			}
	}

	private class ScrollViewDelegate: NSObject, UIScrollViewDelegate {
		private let parent: ProgressAwareScrollView
		private weak var baseDelegate: UICollectionViewDelegate?

		init(parent: ProgressAwareScrollView, baseDelegate: UICollectionViewDelegate?) {
			self.parent = parent
			self.baseDelegate = baseDelegate
		}

		func scrollViewDidScroll(_ scrollView: UIScrollView) {
			baseDelegate?.scrollViewDidScroll?(scrollView)

			let offset = scrollView.contentOffset.y
			let totalHeight = scrollView.contentSize.height - scrollView.frame.height
			parent.progress = CGFloat(offset / totalHeight)
		}

		func scrollViewDidZoom(_ scrollView: UIScrollView) {
			baseDelegate?.scrollViewDidZoom?(scrollView)
		}

		func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
			baseDelegate?.scrollViewDidScrollToTop?(scrollView)
		}

		func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
			baseDelegate?.scrollViewWillBeginDragging?(scrollView)
		}

		func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
			baseDelegate?.scrollViewDidEndDecelerating?(scrollView)
		}

		func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
			baseDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? false
		}

		func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
			baseDelegate?.scrollViewWillBeginDecelerating?(scrollView)
		}

		func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
			baseDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
		}

		func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
			baseDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
		}

		func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
			baseDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
		}

		func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
			baseDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
		}

		func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
			baseDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
		}

		func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
			baseDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
		}
	}
}

extension UIScrollView {
	var strongDelegate: UIScrollViewDelegate? {
		get {
			let key = unsafeBitCast(Selector(#function), to: UnsafeRawPointer.self)
			return objc_getAssociatedObject(self, key) as? UIScrollViewDelegate
		}
		set {
			let key = unsafeBitCast(Selector(#function), to: UnsafeRawPointer.self)
			objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			delegate = newValue
		}
	}
}

#Preview {
	struct Preview: View {
		@State var progress: CGFloat = 0

		var body: some View {
			NavigationStack {
				ProgressAwareScrollView(progress: $progress) {
					LazyVStack(alignment: .leading, spacing: 20) {
						ForEach(0..<100) { index in
							Text("Row \(index + 1)")
						}
					}
				}
				.padding()
				.navigationTitle(progress.description)
			}
		}
	}

	return Preview()
}
