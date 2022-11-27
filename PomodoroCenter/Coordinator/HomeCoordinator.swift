import UIKit

protocol HomeCoordinatorProtocol {
    func goToStatisticsViewController()
}

class HomeCoordinator: Coordinator, HomeCoordinatorProtocol {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeViewController = HomeViewController()
        homeViewController.coordinator = self
        navigationController.pushViewController(homeViewController, animated: true)
    }

    // MARK: - Flow Methods
    func goToStatisticsViewController() {
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.coordinator = self
        navigationController.present(statisticsViewController, animated: true)
    }
}
