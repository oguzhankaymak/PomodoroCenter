import UIKit

final class OnboardingImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configureConstraints()
    }
    
    func configure(with viewModel: OnboardingImageViewModel) {
        self.image = UIImage(named: viewModel.imageName)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFill
    }
    
    private func configureConstraints() {
        let imageViewConstraints : [NSLayoutConstraint] = [
            self.widthAnchor.constraint(equalToConstant: frame.width),
            self.heightAnchor.constraint(equalToConstant: frame.height)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
}
