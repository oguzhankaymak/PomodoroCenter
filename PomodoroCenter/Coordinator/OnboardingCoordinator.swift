import UIKit

protocol OnboardingCoordinatorProtocol {
    func coodinateToHome()
}

class OnboardingCoordinator: Coordinator, OnboardingCoordinatorProtocol {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let onboardViewController = OnboardViewController()
        onboardViewController.coordinator = self
        navigationController.pushViewController(onboardViewController, animated: true)
    }

    // MARK: - Flow Methods
    func coodinateToHome() {
        AppData.isAppOpenedBefore = true
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        coordinate(to: homeCoordinator)
    }
}
