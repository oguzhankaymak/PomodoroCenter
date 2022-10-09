import UIKit

class HomeViewController: UIViewController {
    
    var model: TimeViewModel!
    let timeTypes = [
        NSLocalizedString("pomodoro", comment: "User choose this section if wants to work."),
        NSLocalizedString("break", comment: "User choose this section if wants to rest.")
    ]
    
    private lazy var timeTypesSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: timeTypes)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .white
        segmentedControl.backgroundColor = .black
        
        let font = UIFont.systemFont(ofSize: 14)
        
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black],
            for: .selected
        )
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white],
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
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.setTitle("5", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(shortBreakTimeButtonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var longBreakTimeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.setTitle("15", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(longBreakTimeButtonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 75, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.accessibilityIdentifier = "timeLabel"
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 40
        button.backgroundColor = .black
        button.tintColor = .white
        
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
        button.layer.cornerRadius = 12
        button.backgroundColor = .systemTeal
        button.setTitle(NSLocalizedString("finish", comment: "Title of finish timer button."), for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(finishtimerButtonPress), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        model = TimeViewModel()
        addSubViews()
        configureConstraints()
        subscribeToModel()
    }
    
    @objc func timeTypesSegmentedControlValueChanged(_ segmentedControl: UISegmentedControl){
        if (model.timerIsRunning || !finishTimerButton.isHidden) {
            showWarningMessage(
                title: NSLocalizedString(
                    "warning",
                    comment: "Alert title if user turns off timer while time is running."
                ),
                message:  NSLocalizedString(
                    "timer_turn_off_alert_message",
                    comment: "Alert message if user turns off timer while time is running."
                )) {
                    self.onChangeTimeTypesSegmentedValue(newSelectedSegmentIndex: segmentedControl.selectedSegmentIndex)
                } handlerCancel: {
                    self.cancelTimeTypesSegmentedValue(newSelectedSegmentIndex: segmentedControl.selectedSegmentIndex)
                }
            
        }
        else {
            onChangeTimeTypesSegmentedValue(
                newSelectedSegmentIndex: segmentedControl.selectedSegmentIndex
            )
        }
        
        
    }
    
    private func onChangeTimeTypesSegmentedValue(newSelectedSegmentIndex: Int){
        switch newSelectedSegmentIndex {
        case 0:
            timeTypesSegmentedControl.backgroundColor = .black
            goToPomodoro()
        case 1:
            timeTypesSegmentedControl.backgroundColor = .gray
            goToBreak()
        default:
            break
        }
    }
    
    private func cancelTimeTypesSegmentedValue(newSelectedSegmentIndex: Int){
        switch newSelectedSegmentIndex {
        case 0:
            timeTypesSegmentedControl.selectedSegmentIndex = 1
        case 1:
            timeTypesSegmentedControl.selectedSegmentIndex = 0
        default:
            break
        }
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .systemTeal
        
        let label = UILabel()
        label.textColor = .white
        label.text = "PomodoroCenter"
        label.font = .italicSystemFont(ofSize: 20)
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        let image = UIImage(systemName: "calendar.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(openStatistics))
    }
    
    @objc private func openStatistics(){
        let vc = StatisticsViewController()
        navigationController?.present(vc, animated: true)
    }
    
    private func convertActionButtonToPauseButton(){
        let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        actionButton.setImage(image, for: .normal)
    }
    
    private func convertActionButtonToPlayButton(){
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        actionButton.setImage(image, for: .normal)
    }
    
    private func setStopTimeView(){
        convertActionButtonToPlayButton()
        finishTimerButton.isHidden = false
    }
    
    private func setStartTimeView(){
        convertActionButtonToPauseButton()
        finishTimerButton.isHidden = true
    }
    
    @objc private func actionButtonPress(sender: UIButton){
        if(model.timerIsRunning){
            setStopTimeView()
            model.stopTimer()
        }
        else {
            setStartTimeView()
            model.startTimer()
        }
    }
    
    @objc private func continueButtonPress(sender: UIButton){
        convertActionButtonToPauseButton()
        setStartTimeView()
        model.startTimer()
    }
    
    
    @objc private func finishtimerButtonPress(sender: UIButton){
        convertActionButtonToPlayButton()
        finishTimerButton.isHidden = true
        model.finishtimer()
    }
    
    private func goToPomodoro(){
        setStartTimeView()
        convertActionButtonToPlayButton()
        
        breakTimesView.isHidden = true
        
        timeLabel.textColor = .black
        actionButton.backgroundColor = .black
        
        model.assignTime(timeType: .pomodoro)
    }
    
    private func goToBreak() {
        if !finishTimerButton.isHidden {
            setStartTimeView()
            convertActionButtonToPlayButton()
        }
        
        breakTimesView.isHidden = false
        
        timeLabel.textColor = .gray
        actionButton.backgroundColor = .gray
        model.assignTime(timeType: self.shortBreakTimeButton.backgroundColor == .gray ? .shortBreak : .longBreak)
    }
    
    
    private func setLongBreakTime(){
        shortBreakTimeButton.backgroundColor = .white
        shortBreakTimeButton.setTitleColor(.gray, for: .normal)
        
        longBreakTimeButton.backgroundColor = .gray
        longBreakTimeButton.setTitleColor(.white, for: .normal)
        
        if model.timerIsRunning {
            convertActionButtonToPlayButton()
        }
        else {
            finishTimerButton.isHidden = true
        }
        model.assignTime(timeType: .longBreak)
    }
    
    @objc private func longBreakTimeButtonPress(sender: UIButton){
        if (model.timerIsRunning || !finishTimerButton.isHidden) {
            showWarningMessage(
                title: NSLocalizedString(
                    "warning",
                    comment: "Alert title if user turns off timer while time is running."
                ),
                message:  NSLocalizedString(
                    "timer_turn_off_alert_message",
                    comment: "Alert message if user turns off timer while time is running."
                ),
                handlerOkay: setLongBreakTime,
                handlerCancel: nil
            )
        }
        else {
            setLongBreakTime()
        }
    }
    
    private func setShortBreakTime(){
        longBreakTimeButton.backgroundColor = .white
        longBreakTimeButton.setTitleColor(.gray, for: .normal)
        
        shortBreakTimeButton.backgroundColor = .gray
        shortBreakTimeButton.setTitleColor(.white, for: .normal)
        
        if model.timerIsRunning {
            convertActionButtonToPlayButton()
        }
        else {
            finishTimerButton.isHidden = true
        }
        
        model.assignTime(timeType: .shortBreak)
    }
    
    @objc private func shortBreakTimeButtonPress(sender: UIButton){
        if (model.timerIsRunning || !finishTimerButton.isHidden) {
            showWarningMessage(
                title: NSLocalizedString(
                    "warning",
                    comment: "Alert title if user turns off timer while time is running."
                ),
                message:  NSLocalizedString(
                    "timer_turn_off_alert_message",
                    comment: "Alert message if user turns off timer while time is running."
                ),
                handlerOkay: setShortBreakTime,
                handlerCancel: nil
            )
        }
        else {
            setShortBreakTime()
        }
    }
    
    
    private func subscribeToModel(){
        
        timeLabel.text = model.getFormattedSeconds()
        
        model.onRunningTimer = { [weak self] timeStr in
            self?.timeLabel.text = timeStr
        }
        
        model.onCompleteTimer = { [weak self] activeTimeType in
            self?.convertActionButtonToPlayButton()
            if activeTimeType == TimeType.shortBreak || activeTimeType == TimeType.longBreak {
                self?.timeTypesSegmentedControl.selectedSegmentIndex = 0
                self?.onChangeTimeTypesSegmentedValue(newSelectedSegmentIndex: 0)
            }
            else {
                self?.timeTypesSegmentedControl.selectedSegmentIndex = 1
                self?.onChangeTimeTypesSegmentedValue(newSelectedSegmentIndex: 1)
            }
        }
        
        model.onFinishTimer = { [weak self] timeStr in
            self?.timeLabel.text = timeStr
        }
        
        model.onAssignTimer = { [weak self] timeStr in
            self?.timeLabel.text = timeStr
        }
    }
    
    private func addSubViews(){
        view.addSubview(timeTypesSegmentedControl)
        
        view.addSubview(timeLabel)
        view.addSubview(breakTimesView)
        
        breakTimesView.addSubview(shortBreakTimeButton)
        breakTimesView.addSubview(longBreakTimeButton)
        
        view.addSubview(actionButton)
        view.addSubview(finishTimerButton)
    }
    
    private func configureConstraints(){
        let timeTypesSegmentedControlConstraints: [NSLayoutConstraint] = [
            timeTypesSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height / 10),
            timeTypesSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 50),
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

