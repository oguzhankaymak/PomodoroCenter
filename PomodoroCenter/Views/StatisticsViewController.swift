import UIKit
import Charts

class StatisticsViewController: UIViewController {
    
    var model: StatisticViewModel!
    
    let statisticTypes = [
        NSLocalizedString("weekly", comment: "One of the types of statistics shown on the statistics screen."),
        NSLocalizedString("monthly", comment: "One of the types of statistics shown on the statistics screen.")
    ]
    
    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("statistics", comment: "Title of statistics screen.")
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
        segmentedControl.addTarget(self, action: #selector(statisticTypesSegmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private lazy var barChartView: BarChartView = {
        let barChartView = BarChartView()
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.setLabelCount(6, force: true)
        barChartView.animate(yAxisDuration: 1.5)
        barChartView.accessibilityIdentifier = "barChartView"
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
        lineChartView.accessibilityIdentifier = "lineChartView"
        return lineChartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        model = StatisticViewModel()
        addSubViews()
        configureConstraints()
        subscribeToModel()
        model.getSavedPomodoroTimesByDays()
        model.getSavedPomodoroTimesByMonths()
    }
    
    private func subscribeToModel() {
        model.onGetPomodoroTimesByDays = { [weak self] pomodoroHoursByDays in
            self?.createBarChart(
                pomodoroHoursByDays: pomodoroHoursByDays
            )
        }
        
        model.onGetPomodoroTimesByMonths = {[weak self] pomodoroHoursByMonths in
            self?.createLineChart(
                pomodoroHoursByMonths: pomodoroHoursByMonths
            )
        }
    }
    
    private func addSubViews() {
        view.addSubview(screenTitle)
        view.addSubview(statisticTypeSegmentedControl)
    }
    
    private func configureConstraints() {
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
    
    @objc func statisticTypesSegmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            showBarChart()
        case 1:
            showLineChart()
        default:
            break
        }
        
    }
    
    private func showBarChart() {
        barChartView.animate(yAxisDuration: 1.5)
        lineChartView.isHidden = true
        barChartView.isHidden = false
    }
    
    private func showLineChart() {
        barChartView.isHidden = true
        lineChartView.isHidden = false
        lineChartView.animate(yAxisDuration: 1.5)
    }
    
    private func createBarChart(pomodoroHoursByDays: [TimeByDay]) {
        let xAxis = barChartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: pomodoroHoursByDays.map {
            $0.day
        })
        
        var entries = [BarChartDataEntry]()
        
        for index in 0..<pomodoroHoursByDays.count {
            entries.append(
                BarChartDataEntry(
                    x: Double(index),
                    y: pomodoroHoursByDays[index].hours
                )
                
            )
        }
        
        let set = BarChartDataSet(
            entries: entries,
            label: NSLocalizedString(
                "hour",
                comment: "Time type for chart"
            )
        )
        set.drawValuesEnabled = false
        set.colors = ChartColorTemplates.colorful()
        
        let data = BarChartData(dataSet: set)
        barChartView.data = data
        
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        barChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: numberFormatter)
        
        view.addSubview(barChartView)
        
        let barChartViewConstraints: [NSLayoutConstraint] = [
            barChartView.topAnchor.constraint(equalTo: statisticTypeSegmentedControl.bottomAnchor, constant: 50),
            barChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            barChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            barChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height / 6)
        ]
        
        NSLayoutConstraint.activate(barChartViewConstraints)
    }
    
    private func createLineChart(pomodoroHoursByMonths: [TimeByMonth]){
        let xAxis = lineChartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: pomodoroHoursByMonths.map {
            $0.month
        })
        
        
        var entries = [ChartDataEntry]()
        for index in 0..<pomodoroHoursByMonths.count {
            entries.append(ChartDataEntry(x: Double(index), y: pomodoroHoursByMonths[index].hours))
        }
        
        let set = LineChartDataSet(
            entries: entries,
            label: NSLocalizedString(
                "hour",
                comment: "Time type for chart"
            )
        )
        
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
