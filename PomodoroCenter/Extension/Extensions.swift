import Foundation
import UIKit

extension UIViewController {
    
    func showWarningMessage(title: String, message: String, handlerFunc: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
            handlerFunc()
        }))
        alertController.addAction(UIAlertAction(title: "Vazgeç", style: .cancel))
        self.present(alertController, animated: true, completion: nil)
    }
}
