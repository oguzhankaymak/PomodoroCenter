import UIKit

final class OnboardingDescriptionLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func configure(with viewModel: OnboardingTitleLabelViewModel) {
        self.text = viewModel.text
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = .black
        self.font = AppFont.descriptionOnboarding
        self.textAlignment = .center
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
    }
}
