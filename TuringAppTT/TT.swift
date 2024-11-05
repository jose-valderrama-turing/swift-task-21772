import UIKit

class ImageViewer: UIScrollView, UIScrollViewDelegate {

    // The image view that will display the image
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // The maximum zoom scale
    private let maxZoomScale: CGFloat = 10.0

    // The minimum zoom scale
    private let minZoomScale: CGFloat = 1.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // Setup the scroll view and image view
    private func setup() {
        // Add the image view to the scroll view
        addSubview(imageView)

        // Set the scroll view delegate
        delegate = self

        // Set the maximum and minimum zoom scales
        maximumZoomScale = maxZoomScale
        minimumZoomScale = minZoomScale

        // Ensure the image stays centered
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equaltTo: leadingAnchor),
            imageView.topAnchor.constraint(equaltTo: topAnchor),
            imageView.trailingAnchor.constraint(equaltTo: trailingAnchor)
        ])

        // Add a double tap gesture recognizer to reset the zoom
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGestureRecognizer)
    }

    // Set the image to be displayed
    func setImage(_ image: UIImage) {
        imageView.image = image
        setZoomScale(minZoomScale, animated: false)
    }

    // Handle double tap to reset or zoom the image
    @objc private func handleDoubleTap() {
        if zoomScale > minZoomScale {
            setZoomScale(minZoomScale, animated: true)
        } else {
            setZoomScale(3.0, animated: true)
        }
    }

    // MARK: - UIScrollViewDelegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // Center the image view within the scroll view when zooming
        let offsetX = max(0, (bounds.width - contentSize.width) / 2)
        let offsetY = max(0, (bounds.height - contentSize.height) / 2)
        contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }

    // Prevent panning out of bounds
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = min(max(scrollView.contentOffset.x, 0), scrollView.contentSize.width - scrollView.frame.width)
        let offsetY = min(max(scrollView.contentOffset.y, 0), scrollView.contentSize.height - scrollView.frame.height)
        scrollView.contentOffset = CGPoint(x: offsetX, y: offsetY)
    }
}
