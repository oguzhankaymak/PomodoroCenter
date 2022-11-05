import UIKit

class HomeViewController: UIViewController {

    var coordinator: HomeFlow?

    var model: TimeViewModel!
    let timeTypes = [
        NSLocalizedString("pomodoro", comment: "User choose this section if wants to work."),
        NSLocalizedString("break", comment: "User choose this section if wants to rest.")
    ]

    private lazy var timeTypesSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: timeTypes)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .white
        segmentedControl.backgroundColor = Color.black

        let font = AppFont.segmentedControlTitle

        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: Color.black],
            for: .selected
        )
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: Color.white],
            for: .normal
        )

        segmentedControl.addTarget(self, action: #selector(timeTypesSegmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private lazy var breakTimesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private lazy var shortBreakTimeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = CornerRadius.small
        button.layer.borderColor = BorderColor.gray
        button.layer.borderWidth = 1
        button.setTitle("5", for: .normal)
        button.setTitleColor(
            Color.white,
            for: .normal
        )
        button.backgroundColor = Color.gray
        button.addTarget(self, action: #selector(shortBreakTimeButtonPress), for: .touchUpInside)
        return button
    }()

    private lazy var longBreakTimeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = CornerRadius.small
        button.layer.borderColor = BorderColor.gray
        button.layer.borderWidth = 1
        button.setTitle("15", for: .normal)
        button.setTitleColor(
            Color.gray,
            for: .normal
        )
        button.addTarget(self, action: #selector(longBreakTimeButtonPress), for: .touchUpInside)
        return button
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.extraLargetitle
        label.textColor = Color.black
        label.textAlignment = .center
        label.accessibilityIdentifier = "timeLabel"
        return label
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = CornerRadius.extraLarge
        button.backgroundColor = Color.black
        button.tintColor = Color.white

        button.addTarget(self, action: #selector(actionButtonPress), for: .touchUpInside)

        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)

        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.accessibilityIdentifier = "actionButton"
        return button
    }()

    private lazy var finishTimerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = CornerRadius.normal
        button.backgroundColor = .systemTeal
        button.setTitle(NSLocalizedString("finish", comment: "Title of finish timer button."), for: .normal)
        button.setTitleColor(Color.white, for: .normal)

        button.addTarget(self, action: #selector(finishtimerButtonPress), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureNavigationBar()
        model = TimeViewModel()
        addSubViews()
        configureConstraints()
        subscribeToModel()
    }

    private func addSubViews() {
        view.addSubview(timeTypesSegmentedControl)

        view.addSubview(timeLabel)
        view.addSubview(breakTimesView)

        breakTimesView.addSubview(shortBreakTimeButton)
        breakTimesView.addSubview(longBreakTimeButton)

        view.addSubview(actionButton)
        view.addSubview(finishTimerButton)
    }

    private func convertActionButton(toPauseView: Bool = false) {
        if toPauseView {
            let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            actionButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            actionButton.setImage(image, for: .normal)
        }

    }

    private func setStartTimeView() {
        convertActionButton()
        finishTimerButton.isHidden = true
    }

    private func setStopTimeView() {
        convertActionButton()
        finishTimerButton.isHidden = false
    }

    private func setRunningTimeView() {
        convertActionButton(toPauseView: true)
        finishTimerButton.isHidden = true
    }

    private func setPomodoroView() {
        setStartTimeView()

        breakTimesView.isHidden = true

        timeLabel.textColor = Color.black
        actionButton.backgroundColor = Color.black
        timeTypesSegmentedControl.backgroundColor = Color.black
    }

    private func setBreakView(isLongBreak: Bool) {
        if !finishTimerButton.isHidden {
            setStartTimeView()
        }

        breakTimesView.isHidden = false
        timeLabel.textColor = Color.gray
        actionButton.backgroundColor = Color.gray
        timeTypesSegmentedControl.backgroundColor = Color.gray

        if isLongBreak {
            shortBreakTimeButton.backgroundColor = Color.white
            shortBreakTimeButton.setTitleColor(Color.gray, for: .normal)

            longBreakTimeButton.backgroundColor = Color.gray
            longBreakTimeButton.setTitleColor(Color.white, for: .normal)
        } else {
            longBreakTimeButton.backgroundColor = Color.white
            longBreakTimeButton.setTitleColor(Color.gray, for: .normal)

            shortBreakTimeButton.backgroundColor = Color.gray
            shortBreakTimeButton.setTitleColor(Color.white, for: .normal)
        }
    }

    private func setShortBreakTime() {
        longBreakTimeButton.backgroundColor = Color.white
        longBreakTimeButton.setTitleColor(Color.gray, for: .normal)

        shortBreakTimeButton.backgroundColor = Color.gray
        shortBreakTimeButton.setTitleColor(Color.white, for: .normal)

        finishTimerButton.isHidden = true
    }

    private func changeTimer(timeType: TimeType, isForce: Bool = false) {
        if isForce {
            model.stopTimer()
        }

        model.assignTime(timeType: timeType)
    }

    private func sendNotificationIfAppIsBackgroundOrInactive(completedTimeType: TimeType) {
        let state = UIApplication.shared.applicationState
        if state == .background || state == .inactive {
            model.sendNotification(completedTimeType: completedTimeType)
        }
    }

    @objc private func actionButtonPress(sender: UIButton) {
        if model.timerIsRunning {
            model.stopTimer()
        } else {
            model.startTimer()
        }
    }

    @objc private func finishtimerButtonPress(sender: UIButton) {
        model.finishtimer()
    }

    @objc private func longBreakTimeButtonPress(sender: UIButton) {
        changeTimer(timeType: .longBreak)
    }

    @objc private func shortBreakTimeButtonPress(sender: UIButton) {
        changeTimer(timeType: .shortBreak)
    }
}

// MARK: - SubscribeToModel
extension HomeViewController {

    private func subscribeToModel() {
        timeLabel.text = model.getFormattedSeconds()

        model.onStartedTimer = {
            self.setRunningTimeView()
        }

        model.onStoppedTimer = {
            self.setStopTimeView()
        }

        model.onRunningTimer = { [weak self] timeStr in
            self?.timeLabel.text = timeStr
        }

        model.onCompletedTimer = { [weak self] activeTimeType in
            self?.convertActionButton()
            self?.sendNotificationIfAppIsBackgroundOrInactive(completedTimeType: activeTimeType)

            if activeTimeType == TimeType.shortBreak || activeTimeType == TimeType.longBreak {
                self?.timeTypesSegmentedControl.selectedSegmentIndex = 0
                self?.timeTypeSegmentIndexChanged(newSelectedSegmentIndex: 0)
            } else {
                self?.timeTypesSegmentedControl.selectedSegmentIndex = 1
                self?.timeTypeSegmentIndexChanged(newSelectedSegmentIndex: 1)
            }
        }

        model.onFinishedTimer = { [weak self] timeStr in
            self?.timeLabel.text = timeStr
            self?.convertActionButton()
            self?.finishTimerButton.isHidden = true
        }

        model.onAssignedTimer = { [weak self] assignTimeModel in
            if assignTimeModel.error != nil {
                self?.showWarningMessage(
                    title: NSLocalizedString(
                        "warning",
                        comment: "Alert title if user turns off timer while time is running."
                    ),
                    message: NSLocalizedString(
                        "timer_turn_off_alert_message",
                        comment: "Alert message if user turns off timer while time is running."
                    ),
                    handlerOkay: {
                        self?.changeTimer(timeType: assignTimeModel.assignedTimeType, isForce: true)
                    },
                    handlerCancel: {
                        self?.changeTimeTypeSegmentIndexByTimeType(timeType: assignTimeModel.activeTimeType)
                    }
                )
            } else {
                self?.timeLabel.text = assignTimeModel.formatedSeconds

                if assignTimeModel.activeTimeType == TimeType.pomodoro {
                    self?.setPomodoroView()
                } else if assignTimeModel.activeTimeType == .shortBreak {
                    self?.setBreakView(isLongBreak: false)
                } else if assignTimeModel.activeTimeType == .longBreak {
                    self?.setBreakView(isLongBreak: true)
                }
            }

        }
    }
}

// MARK: - NavigationBar
extension HomeViewController {

    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = Color.white
        navigationController?.navigationBar.backgroundColor = Color.teal

        let label = UILabel()
        label.textColor = Color.white
        label.text = "PomodoroCenter"
        label.font = AppFont.navigationBarItalic

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)

        let image = UIImage(
            systemName: "calendar.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)
        )

        let rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(openStatistics)
        )

        rightBarButtonItem.accessibilityIdentifier = "calendar"

        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc private func openStatistics() {
        coordinator?.goToStatisticsViewController()
    }
}

// MARK: - UISegmentedControl
extension HomeViewController {

    @objc func timeTypesSegmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        if !finishTimerButton.isHidden {
            showWarningMessage(
                title: NSLocalizedString(
                    "warning",
                    comment: "Alert title if user turns off timer while time is running."
                ),
                message: NSLocalizedString(
                    "timer_turn_off_alert_message",
                    comment: "Alert message if user turns off timer while time is running."
                ),
                handlerOkay: {
                    self.timeTypeSegmentIndexChanged(newSelectedSegmentIndex: segmentedControl.selectedSegmentIndex)
                },
                handlerCancel: {
                    self.cancelTimeTypeSegmentedValue(newSelectedSegmentIndex: segmentedControl.selectedSegmentIndex)
                }
            )
        } else {
            timeTypeSegmentIndexChanged(
                newSelectedSegmentIndex: segmentedControl.selectedSegmentIndex
            )
        }
    }

    private func timeTypeSegmentIndexChanged(newSelectedSegmentIndex: Int) {
        switch newSelectedSegmentIndex {
        case 0:
            changeTimer(timeType: .pomodoro)
        case 1:
            changeTimer(timeType: .shortBreak)
        default:
            break
        }
    }

    private func cancelTimeTypeSegmentedValue(newSelectedSegmentIndex: Int) {
        switch newSelectedSegmentIndex {
        case 0:
            timeTypesSegmentedControl.selectedSegmentIndex = 1
        case 1:
            timeTypesSegmentedControl.selectedSegmentIndex = 0
        default:
            break
        }
    }

    private func changeTimeTypeSegmentIndexByTimeType(timeType: TimeType) {
        if timeType == TimeType.pomodoro {
            timeTypesSegmentedControl.selectedSegmentIndex = 0
        } else if timeType == .shortBreak {
            timeTypesSegmentedControl.selectedSegmentIndex = 1
        } else if timeType == .longBreak {
            timeTypesSegmentedControl.selectedSegmentIndex = 1
        }
    }
}

// MARK: - Constraints
extension HomeViewController {

    private func configureConstraints() {
        let timeTypesSegmentedControlConstraints: [NSLayoutConstraint] = [
            timeTypesSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height / 10),
            timeTypesSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            timeTypesSegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            timeTypesSegmentedControl.heightAnchor.constraint(equalToConstant: 35)]

        let timeLabelConstraints: [NSLayoutConstraint] = [
            timeLabel.topAnchor.constraint(equalTo: timeTypesSegmentedControl.bottomAnchor, constant: view.frame.height / 10),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)]

        let shortBreakTimeButtonConstraints: [NSLayoutConstraint] = [
            shortBreakTimeButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            shortBreakTimeButton.widthAnchor.constraint(equalToConstant: 50),
            shortBreakTimeButton.heightAnchor.constraint(equalToConstant: 35)]

        let longBreakTimeButtonConstraints: [NSLayoutConstraint] = [
            longBreakTimeButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            longBreakTimeButton.widthAnchor.constraint(equalToConstant: 50),
            longBreakTimeButton.heightAnchor.constraint(equalToConstant: 35)]

        let breakTimesViewConstraints: [NSLayoutConstraint] = [
            breakTimesView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: view.frame.height / 20),
            breakTimesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            breakTimesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            breakTimesView.heightAnchor.constraint(equalToConstant: 35)]

        let actionButtonConstraints: [NSLayoutConstraint] = [
            actionButton.widthAnchor.constraint(equalToConstant: 80),
            actionButton.heightAnchor.constraint(equalToConstant: 80),
            actionButton.topAnchor.constraint(equalTo: breakTimesView.bottomAnchor, constant: view.frame.height / 20),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)]

        let finishTimerButtonConstraints: [NSLayoutConstraint] = [
            finishTimerButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: view.frame.height / 22),
            finishTimerButton.widthAnchor.constraint(equalToConstant: 100),
            finishTimerButton.heightAnchor.constraint(equalToConstant: 35),
            finishTimerButton.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor)]

        NSLayoutConstraint.activate(timeTypesSegmentedControlConstraints)
        NSLayoutConstraint.activate(timeLabelConstraints)
        NSLayoutConstraint.activate(shortBreakTimeButtonConstraints)
        NSLayoutConstraint.activate(longBreakTimeButtonConstraints)
        NSLayoutConstraint.activate(breakTimesViewConstraints)
        NSLayoutConstraint.activate(actionButtonConstraints)
        NSLayoutConstraint.activate(finishTimerButtonConstraints)
    }
}
