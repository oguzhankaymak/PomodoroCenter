import UIKit

class StatisticsViewController: UIViewController {
    
    let statisticTypes = ["Haftalık", "Aylık"]
    
    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "İstatistikler"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private lazy var statisticTypeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: statisticTypes)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .black
        segmentedControl.backgroundColor = .black
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.black],
            for: .selected
        )
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .normal
        )
        segmentedControl.addTarget(self, action: #selector(suitDidChange(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        configureConstraints()
    }
    
    private func addSubViews(){
        view.addSubview(screenTitle)
        view.addSubview(statisticTypeSegmentedControl)
    }
    
    private func configureConstraints(){
        let screenTitleConstraints: [NSLayoutConstraint] = [
            screenTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        
        let statisticTypeSegmentedControlConstraints: [NSLayoutConstraint] = [
            statisticTypeSegmentedControl.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 50),
            statisticTypeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticTypeSegmentedControl.widthAnchor.constraint(equalToConstant: 300)
        ]
        
        NSLayoutConstraint.activate(screenTitleConstraints)
        NSLayoutConstraint.activate(statisticTypeSegmentedControlConstraints)
    }
    
    @objc func suitDidChange(_ segmentedControl: UISegmentedControl){
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("haftalık")
        case 1:
            print("aylık")
        default:
            print("default")
        }
        
    }

}
