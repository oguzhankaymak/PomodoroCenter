import UIKit

class HomeViewController: UIViewController {
    
    var model: TimeViewModel!
    
    private lazy var timeTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        return stackView
    }()
    
    private lazy var pomodoroButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Pomodoro", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(pomodoroButtonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var breakButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Break", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(breakButtonPress), for: .touchUpInside)
        return button
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
    
    private lazy var timeText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "25 : 00"
        label.font = .systemFont(ofSize: 78, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
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
        return button
    }()
    
    private lazy var finishTimerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.backgroundColor = .systemTeal
        button.setTitle("Bitir", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(finishtimerButtonPress), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        model = TimeViewModel()
        addSubViews()
        configureConstraints()
        subscribeToModel()
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
        breakButton.backgroundColor = .white
        breakButton.setTitleColor(.gray, for: .normal)
        
        pomodoroButton.backgroundColor = .black
        pomodoroButton.setTitleColor(.white, for: .normal)
        
        timeText.textColor = .black
        actionButton.backgroundColor = .black
        
        model.setTime(timeType: .pomodoro)
    }
    
    @objc private func pomodoroButtonPress(sender: UIButton){
        if (model.timerIsRunning || !finishTimerButton.isHidden) {
            showWarningMessage(title: "Uyarı", message: "Çalışmış olduğunuz zaman kaybedilecek. Emin misiniz?", handlerFunc: goToPomodoro)
        }
        else {
            goToPomodoro()
        }
    }
    
    private func goToBreak() {
        if !finishTimerButton.isHidden {
            setStartTimeView()
            convertActionButtonToPlayButton()
        }
        
        breakTimesView.isHidden = false
        pomodoroButton.backgroundColor = .white
        pomodoroButton.setTitleColor(.black, for: .normal)
        
        breakButton.backgroundColor = .gray
        breakButton.setTitleColor(.white, for: .normal)
        
        timeText.textColor = .gray
        actionButton.backgroundColor = .gray
        model.setTime(timeType: self.shortBreakTimeButton.backgroundColor == .gray ? .shortBreak : .longBreak)
    }
    
    @objc private func breakButtonPress(sender: UIButton){
        if (model.timerIsRunning || !finishTimerButton.isHidden) {
            showWarningMessage(title: "Uyarı", message: "Çalışmış olduğunuz zaman kaybedilecek. Emin misiniz?", handlerFunc: goToBreak)
        }
        else {
            goToBreak()
        }
        
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
        model.setTime(timeType: .longBreak)
    }
    
    @objc private func longBreakTimeButtonPress(sender: UIButton){
        if (model.timerIsRunning || !finishTimerButton.isHidden) {
            showWarningMessage(title: "Uyarı", message: "Çalışmış olduğunuz zaman kaybedilecek. Emin misiniz?", handlerFunc: setLongBreakTime)
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
        
        model.setTime(timeType: .shortBreak)
    }
    
    @objc private func shortBreakTimeButtonPress(sender: UIButton){
        if (model.timerIsRunning || !finishTimerButton.isHidden) {
            showWarningMessage(title: "Uyarı", message: "Çalışmış olduğunuz zaman kaybedilecek. Emin misiniz?", handlerFunc: setShortBreakTime)
        }
        else {
            setShortBreakTime()
        }
    }
    
    
    private func subscribeToModel(){
        model.onRunningTime = { [weak self] timeStr in
            self?.timeText.text = timeStr
        }
        
        model.onCompleteTime = { [weak self] activeTimeType in
            self?.convertActionButtonToPlayButton()
            if activeTimeType == TimeType.shortBreak || activeTimeType == TimeType.longBreak {
                self?.goToPomodoro()
            }
            else {
                self?.goToBreak()
            }
        }
        
        model.onFinishTimer = { [weak self] timeStr in
            self?.timeText.text = timeStr
        }
        
        model.onSetTimer = { [weak self] timeStr in
            self?.timeText.text = timeStr
        }
    }
    
    private func addSubViews(){
        view.addSubview(timeTypeStackView)
        timeTypeStackView.addArrangedSubview(pomodoroButton)
        timeTypeStackView.addArrangedSubview(breakButton)
        
        view.addSubview(timeText)
        view.addSubview(breakTimesView)
        
        breakTimesView.addSubview(shortBreakTimeButton)
        breakTimesView.addSubview(longBreakTimeButton)
        
        view.addSubview(actionButton)
        view.addSubview(finishTimerButton)
    }
    
    private func configureConstraints(){
        let timeTypeStackViewConstraints: [NSLayoutConstraint] = [
            timeTypeStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            timeTypeStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 50),
            timeTypeStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50)]
        
        let timeTextConstraints: [NSLayoutConstraint] = [
            timeText.topAnchor.constraint(equalTo: timeTypeStackView.bottomAnchor, constant: 70),
            timeText.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        
        let shortBreakTimeButtonConstraints: [NSLayoutConstraint] = [
            shortBreakTimeButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            shortBreakTimeButton.widthAnchor.constraint(equalToConstant: 50),
            shortBreakTimeButton.heightAnchor.constraint(equalToConstant: 35)]
        
        let longBreakTimeButtonConstraints: [NSLayoutConstraint] = [
            longBreakTimeButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            longBreakTimeButton.widthAnchor.constraint(equalToConstant: 50),
            longBreakTimeButton.heightAnchor.constraint(equalToConstant: 35)]
        
        let breakTimesViewConstraints: [NSLayoutConstraint] = [
            breakTimesView.topAnchor.constraint(equalTo: timeText.bottomAnchor, constant: 40),
            breakTimesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            breakTimesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            breakTimesView.heightAnchor.constraint(equalToConstant: 35)]
        
        let actionButtonConstraints: [NSLayoutConstraint] = [
            actionButton.widthAnchor.constraint(equalToConstant: 80),
            actionButton.heightAnchor.constraint(equalToConstant: 80),
            actionButton.topAnchor.constraint(equalTo: breakTimesView.bottomAnchor, constant: 50),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        
        let finishTimerButtonConstraints: [NSLayoutConstraint] = [
            finishTimerButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 50),
            finishTimerButton.widthAnchor.constraint(equalToConstant: 100),
            finishTimerButton.heightAnchor.constraint(equalToConstant: 35),
            finishTimerButton.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor)]
        
        NSLayoutConstraint.activate(timeTypeStackViewConstraints)
        NSLayoutConstraint.activate(timeTextConstraints)
        NSLayoutConstraint.activate(shortBreakTimeButtonConstraints)
        NSLayoutConstraint.activate(longBreakTimeButtonConstraints)
        NSLayoutConstraint.activate(breakTimesViewConstraints)
        NSLayoutConstraint.activate(actionButtonConstraints)
        NSLayoutConstraint.activate(finishTimerButtonConstraints)
    }
    
    
}

