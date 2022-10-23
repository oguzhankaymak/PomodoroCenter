import UIKit

protocol StartFlow {
    func goToStatisticsViewController()
    func goToHomeViewController()
}

class StartCoordinator: Coordinator, StartFlow {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let coordinator : Coordinator = AppData.isAppOpenedBefore
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
}
