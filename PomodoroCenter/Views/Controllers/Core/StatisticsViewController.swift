import UIKit
import Charts

class StatisticsViewController: UIViewController {

    var coordinator: HomeCoordinatorProtocol?
    var model: StatisticViewModel!

    let statisticTypes = [
        NSLocalizedString("weekly", comment: "One of the types of statistics shown on the statistics screen."),
        NSLocalizedString("monthly", comment: "One of the types of statistics shown on the statistics screen.")
    ]

    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("statistics", comment: "Title of statistics screen.")
        label.font = AppFont.title
        return label
    }()

    private lazy var statisticTypeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: statisticTypes)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = Color.black
        segmentedControl.backgroundColor = Color.black
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: Color.black],
            for: .selected
        )
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: Color.white],
            for: .normal
        )
        segmentedControl.addTarget(
            self,
            action: #selector(statisticTypesSegmentedControlValueChanged(_:)),
            for: .valueChanged
        )
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private lazy var contentViewByWeek: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentViewByMonth: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private lazy var barChartView: BarChartView = {
        let barChartView = BarChartView()
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.axisMinimum = 0
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
        lineChartView.animate(yAxisDuration: 1.5)
        lineChartView.accessibilityIdentifier = "lineChartView"
        return lineChartView
    }()

    private lazy var emptyDataByDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString(
            "noDataForThisWeek",
            comment: "If there is no data in database for this week. Show this message."
        )
        label.font = AppFont.emptyText
        label.textColor = Color.black
        return label
    }()

    private lazy var emptyDataByMonthsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString(
            "noDataForThisMonth",
            comment: "If there is no data in database for this week. Show this message."
        )
        label.font = AppFont.emptyText
        label.textColor = Color.black
        return label
    }()

// MARK: - viewDidLoad
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

    private func addSubViews() {
        view.addSubview(screenTitle)
        view.addSubview(statisticTypeSegmentedControl)
        view.addSubview(contentViewByWeek)
        view.addSubview(contentViewByMonth)
    }

    @objc func statisticTypesSegmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            showContentViewByWeek()
        case 1:
            showContentViewByMonth()
        default:
            break
        }

    }

    private func setEmptyDataLabel(isDaysData: Bool) {
        if isDaysData {
            contentViewByWeek.addSubview(emptyDataByDaysLabel)

        } else {
            contentViewByMonth.addSubview(emptyDataByMonthsLabel)
        }

        let emptyDataByDaysLabelConstraints: [NSLayoutConstraint] = [
            emptyDataByDaysLabel.centerXAnchor.constraint(
                equalTo: contentViewByWeek.centerXAnchor
            ),

            emptyDataByDaysLabel.centerYAnchor.constraint(
                equalTo: contentViewByWeek.centerYAnchor
            )
        ]

        let emptyDataByMonthsLabelConstraints: [NSLayoutConstraint] = [
            emptyDataByMonthsLabel.centerXAnchor.constraint(
                equalTo: contentViewByMonth.centerXAnchor
            ),

            emptyDataByMonthsLabel.centerYAnchor.constraint(
                equalTo: contentViewByMonth.centerYAnchor
            )
        ]

        NSLayoutConstraint.activate(
            isDaysData
                ? emptyDataByDaysLabelConstraints
                : emptyDataByMonthsLabelConstraints
        )
    }

}

// MARK: - SubscribeToModel
extension StatisticsViewController {
    private func subscribeToModel() {
        model.pomodoroHoursByDays.bind { [weak self] pomodoroHoursByDays in
            guard let data = pomodoroHoursByDays else { return }
            var isAllValuesZero = true

            for timeByDay in data where timeByDay.hours != 0 {
                isAllValuesZero = false
                break
            }

            if isAllValuesZero {
                self?.setEmptyDataLabel(isDaysData: true)

            } else {
                self?.createBarChart(
                    pomodoroHoursByDays: data
                )
            }
        }

        model.pomodoroHoursByMonths.bind { [weak self] pomodoroHoursByMonths in
            guard let data = pomodoroHoursByMonths else { return }
            var isAllValuesZero = true

            for timeByMonth in data where timeByMonth.hours != 0 {
                isAllValuesZero = false
                break
            }

            if isAllValuesZero {
                self?.setEmptyDataLabel(isDaysData: false)

            } else {
                self?.createLineChart(
                    pomodoroHoursByMonths: data
                )
            }

        }
    }
}

// MARK: - Charts
extension StatisticsViewController {

    private func showContentViewByWeek() {
        contentViewByWeek.isHidden = false
        contentViewByMonth.isHidden = true

        barChartView.animate(yAxisDuration: 1.5)
    }

    private func showContentViewByMonth() {
        contentViewByWeek.isHidden = true
        contentViewByMonth.isHidden = false
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

        set.colors = ChartColorTemplates.colorful()

        let data = BarChartData(dataSet: set)
        barChartView.data = data

        contentViewByWeek.addSubview(barChartView)

        let barChartViewConstraints: [NSLayoutConstraint] = [
            barChartView.topAnchor.constraint(equalTo: contentViewByWeek.topAnchor),
            barChartView.leadingAnchor.constraint(equalTo: contentViewByWeek.leadingAnchor, constant: 10),
            barChartView.trailingAnchor.constraint(equalTo: contentViewByWeek.trailingAnchor, constant: -10),
            barChartView.bottomAnchor.constraint(equalTo: contentViewByWeek.bottomAnchor, constant: -200)
        ]

        NSLayoutConstraint.activate(barChartViewConstraints)
    }

    private func createLineChart(pomodoroHoursByMonths: [TimeByMonth]) {
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

        contentViewByMonth.addSubview(lineChartView)

        let lineChartViewConstraints: [NSLayoutConstraint] = [
            lineChartView.topAnchor.constraint(equalTo: contentViewByMonth.topAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: contentViewByMonth.leadingAnchor, constant: 10),
            lineChartView.trailingAnchor.constraint(equalTo: contentViewByMonth.trailingAnchor, constant: -10),
            lineChartView.bottomAnchor.constraint(equalTo: contentViewByMonth.bottomAnchor, constant: -200)
        ]

        NSLayoutConstraint.activate(lineChartViewConstraints)
    }
}

// MARK: - Constraints
extension StatisticsViewController {

    private func configureConstraints() {
        let screenTitleConstraints: [NSLayoutConstraint] = [
            screenTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]

        let statisticTypeSegmentedControlConstraints: [NSLayoutConstraint] = [
            statisticTypeSegmentedControl.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 50),
            statisticTypeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticTypeSegmentedControl.widthAnchor.constraint(equalToConstant: 300)
        ]

        let contentViewByWeekConstraints: [NSLayoutConstraint] = [
            contentViewByWeek.topAnchor.constraint(equalTo: statisticTypeSegmentedControl.bottomAnchor, constant: 50),
            contentViewByWeek.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentViewByWeek.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentViewByWeek.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        let contentViewByMonthConstraints: [NSLayoutConstraint] = [
            contentViewByMonth.topAnchor.constraint(equalTo: statisticTypeSegmentedControl.bottomAnchor, constant: 50),
            contentViewByMonth.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentViewByMonth.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentViewByMonth.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(screenTitleConstraints)
        NSLayoutConstraint.activate(statisticTypeSegmentedControlConstraints)
        NSLayoutConstraint.activate(contentViewByWeekConstraints)
        NSLayoutConstraint.activate(contentViewByMonthConstraints)
    }
}
