import UIKit

class ThirdPageOnboardViewController: UIViewController {
    
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "chart")
        return imageView
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("chartTitle", comment: "Third onboarding screen title.")
        label.textColor = .black
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("chartDescription", comment: "Third onboarding screen descriptipn.")
        label.textColor = .black
        label.font = .italicSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var skipButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitle(NSLocalizedString("skip", comment: "Skip button on last onboarding screen."), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(skipButtonPress), for: .touchUpInside)
        return button
    }()
    
    @objc private func skipButtonPress(sender: UIButton) {
        let homeViewController = HomeViewController()
        UserDefaults.standard.isAppOpenedBefore = true
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.79, green: 0.87, blue: 0.94, alpha: 1)
        addSubViews()
        configureConstraints()
    }
    
    private func addSubViews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(skipButton)
    }
    
    private func configureConstraints() {
        let imageViewConstraints : [NSLayoutConstraint] = [
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width / 4),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height / 4),
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
