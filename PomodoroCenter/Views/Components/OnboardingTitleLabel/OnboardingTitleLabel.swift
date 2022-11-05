import UIKit

final class OnboardingTitleLabel: UILabel {

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
        self.textColor = Color.black
        self.font = AppFont.title
    }
}
