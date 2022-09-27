import UIKit
import Charts

class StatisticsViewController: UIViewController {
    
    var model: StatisticViewModel!
    
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
    
    private lazy var barChartView: BarChartView = {
        let barChartView = BarChartView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: view.frame.size.width,
                                                      height: view.frame.size.width)
        )
        
        
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        
        return barChartView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        model = StatisticViewModel()
        addSubViews()
        configureConstraints()
        subscribeToModel()
        model.getSavedPomodoroTimesByDay()
    }
    
    private func subscribeToModel(){
        model.getPomodoroTimesByDay = { [weak self] datas in
            self?.createBarChart(datas: datas)
        }
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
            barChartView.animate(yAxisDuration: 1.5)
            barChartView.isHidden = false
        case 1:
            barChartView.isHidden = true
        default:
            print("default")
        }
        
    }
    
    private func createBarChart(datas: [TimeByDay]){
        let xAxis = barChartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: datas.map {
            $0.dayOfWeek
        })
        
        xAxis.labelPosition = .bottom
        
        let rightAxis = barChartView.rightAxis
        rightAxis.enabled = false

        
        let leftAxis = barChartView.leftAxis
        leftAxis.axisMinimum = 0

        barChartView.animate(yAxisDuration: 1.5)
        
        var entries = [BarChartDataEntry]()
        
        for index in 0..<datas.count {
            entries.append(
                BarChartDataEntry(
                    x: Double(index),
                    y: datas[index].minutes
                )
            
            )
        }
        
        let set = BarChartDataSet(entries: entries, label: "Dakika")
        set.drawValuesEnabled = false
        set.colors = ChartColorTemplates.colorful()
        let data = BarChartData(dataSet: set)
        
        barChartView.data = data
        view.addSubview(barChartView)
        
        let barChartViewConstraints: [NSLayoutConstraint] = [
            barChartView.topAnchor.constraint(equalTo: statisticTypeSegmentedControl.bottomAnchor, constant: 80),
            barChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200)
        ]
        
        NSLayoutConstraint.activate(barChartViewConstraints)
    }
}
