import UIKit

class NotificationOnboardViewController: UIViewController {
    
    private var coordinator: OnboardingFlow?
    
    private lazy var imageView: UIImageView = {
        let imageView = OnboardingImageView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.frame.width / 4,
                height: view.frame.height / 4
            )
        )
        imageView.configure(with: OnboardingImageViewModel(imageName: "notification"))
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = OnboardingTitleLabel()
        label.configure(
            with: OnboardingTitleLabelViewModel(
                text: NSLocalizedString("notifications", comment: "Notification onboarding screen title.")
            )
        )
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = OnboardingDescriptionLabel()
        label.configure(
            with: OnboardingTitleLabelViewModel(
                text: NSLocalizedString("notificationOnBoardingDescription", comment: "Notification onboarding screen description.")
            )
        )
        return label
    }()
    
    private lazy var skipButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitle(NSLocalizedString("skip", comment: "Skip button on last onboarding screen."), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = CornerRadius.normal
        button.addTarget(self, action: #selector(skipButtonPress), for: .touchUpInside)
        return button
    }()
    
    @objc private func skipButtonPress(sender: UIButton) {
        requestNotificationPermission()
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.onboardingBackgroundColor
        addSubViews()
        configureConstraints()
    }
    
    init(coordinator: OnboardingFlow?) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.coordinator?.coodinateToHome()
            }
        }
    }
    
    private func addSubViews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(skipButton)
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
        
        let skipButtonConstraints: [NSLayoutConstraint] = [
            skipButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height / 6),
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            skipButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(skipButtonConstraints)
    }
}
