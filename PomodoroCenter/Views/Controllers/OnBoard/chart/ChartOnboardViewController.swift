import UIKit

class ChartOnboardViewController: UIViewController {
    
    private lazy var imageView : UIImageView = {
        let imageView = OnboardingImageView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.frame.width / 4,
                height: view.frame.height / 4
            )
        )
        imageView.configure(with: OnboardingImageViewModel(imageName: "chart"))
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = OnboardingTitleLabel()
        label.configure(
            with: OnboardingTitleLabelViewModel(
                text: NSLocalizedString("chartTitle", comment: "Chart onboarding screen title.")
            )
        )
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = OnboardingDescriptionLabel()
        label.configure(
            with: OnboardingTitleLabelViewModel(
                text: NSLocalizedString("chartDescription", comment: "Chart onboarding screen description.")
            )
        )
        return label
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.onboardingBackgroundColor
        addSubViews()
        configureConstraints()
    }
    
    private func addSubViews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
    }
    
    private func configureConstraints() {
        let imageViewConstraints : [NSLayoutConstraint] = [
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 6)
        ]
        
        let titleLabelConstraints : [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: view.frame.height / 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let descriptionLabelConstraints: [NSLayoutConstraint] = [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: view.frame.height / 14),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
    }
}
