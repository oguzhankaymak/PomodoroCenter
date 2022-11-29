import UIKit

protocol StartCoordinatorProtocol {
    func goToStatisticsViewController()
    func goToHomeViewController()
}

class StartCoordinator: Coordinator, StartCoordinatorProtocol {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let coordinator: Coordinator = AppData.isAppOpenedBefore || isCheckLaunchArgumentsIsAppOpenedBefore()
        ? HomeCoordinator(navigationController: navigationController)
        : OnboardingCoordinator(navigationController: navigationController)

        coordinate(to: coordinator)
    }

    // MARK: - Flow Methods
    func goToStatisticsViewController() {
        let controller = StatisticsViewController()
        navigationController.present(controller, animated: true)
    }

    func goToHomeViewController() {
        let controller = HomeViewController()
        navigationController.pushViewController(controller, animated: true)
    }

    // MARK: - Private Methods
    private func isCheckLaunchArgumentsIsAppOpenedBefore () -> Bool {
        let tempIndex = CommandLine.arguments.lastIndex(of: "-isAppOpenedBefore")
        if let index = tempIndex {
            return CommandLine.arguments[index + 1] == "true"
        }
        return false
    }
}
