import UIKit

protocol OnboardingFlow {
    func coodinateToHome()
}

class OnboardingCoordinator: Coordinator, OnboardingFlow {
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
        UserDefaults.standard.isAppOpenedBefore = true
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        coordinate(to: homeCoordinator)
    }
}
