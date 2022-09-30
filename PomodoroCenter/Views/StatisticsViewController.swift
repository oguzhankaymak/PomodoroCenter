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
        let barChartView = BarChartView()
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.axisMinimum = 0
        barChartView.animate(yAxisDuration: 1.5)
        return barChartView
    }()
    
    private lazy var lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.axisMinimum = 1
        lineChartView.xAxis.setLabelCount(6, force: true)
        lineChartView.isHidden = true
        lineChartView.animate(yAxisDuration: 1.5)
        return lineChartView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        model = StatisticViewModel()
        addSubViews()
        configureConstraints()
        subscribeToModel()
        model.getSavedPomodoroTimesByDay()
        model.getSavedPomodoroTimesByMonth()
    }
    
    private func subscribeToModel(){
        model.getPomodoroTimesByDay = { [weak self] datas in
            self?.createBarChart(datas: datas)
        }
        
        model.getPomodoroTimesByMonth = {[weak self] datas in
            self?.createLineChart(datas: datas)
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
            showBarChart()
        case 1:
            showLineChart()
        default:
            break
        }
        
    }
    
    private func showBarChart(){
        barChartView.animate(yAxisDuration: 1.5)
        lineChartView.isHidden = true
        barChartView.isHidden = false
    }
    
    private func showLineChart(){
        barChartView.isHidden = true
        lineChartView.isHidden = false
        lineChartView.animate(yAxisDuration: 1.5)
    }
    
    private func createBarChart(datas: [TimeByDay]){
        let xAxis = barChartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: datas.map {
            $0.dayOfWeek
        })
        
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
            barChartView.topAnchor.constraint(equalTo: statisticTypeSegmentedControl.bottomAnchor, constant: 50),
            barChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            barChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            barChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height / 6)
        ]
        
        NSLayoutConstraint.activate(barChartViewConstraints)
    }
    
    private func createLineChart(datas: [TimeByMonth]){
        let xAxis = lineChartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: datas.map {
            $0.monthOfYear
        })
        
        
        var entries = [ChartDataEntry]()
        for index in 0..<datas.count {
            entries.append(ChartDataEntry(x: Double(index), y: datas[index].hours))
        }
        
        let set = LineChartDataSet(entries: entries, label: "Saat")
        set.mode = .linear
        set.lineWidth = 3
        set.fill = ColorFill(color: .systemBlue)
        set.fillAlpha = 0.8
        set.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        lineChartView.data = data
        
        view.addSubview(lineChartView)
        
        let lineChartViewConstraints: [NSLayoutConstraint] = [
            lineChartView.topAnchor.constraint(equalTo: statisticTypeSegmentedControl.bottomAnchor, constant: 50),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            lineChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height / 6)
        ]
        
        NSLayoutConstraint.activate(lineChartViewConstraints)
    }
}
