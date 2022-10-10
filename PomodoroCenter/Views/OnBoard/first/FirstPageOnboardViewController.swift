//
//  FirstPageOnBoardViewController.swift
//  PomodoroCenter
//
//  Created by Oğuzhan Kaymak on 9.10.2022.
//

import UIKit

class FirstPageOnboardViewController: UIViewController {
    
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "productivity")
        return imageView
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("productivityTitle", comment: "First onboarding screen title.")
        label.textColor = .black
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("productivityDescription", comment: "First onboarding screen description.")
        label.textColor = .black
        label.font = .italicSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.79, green: 0.87, blue: 0.94, alpha: 1)
        addSubViews()
        configureConstraints()
        
    }
    
    private func addSubViews(){
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
    }
    
    private func configureConstraints(){
        let imageViewConstraints : [NSLayoutConstraint] = [
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width / 4),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height / 4),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 5)
        ]
        
        let titleLabelConstraints : [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let descriptionLabelConstraints: [NSLayoutConstraint] = [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
    }
    

}