import Foundation
import UIKit

extension UIViewController {

    func showWarningMessage(
        title: String,
        message: String,
        handlerOkay: (() -> Void)?,
        handlerCancel: (() -> Void)?
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addAction(
            UIAlertAction(
                title: NSLocalizedString("okay", comment: "Alert ok button"),
                style: .default,
                handler: { _ in
                    handlerOkay?()
                }))

        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("cancel", comment: "Alert cancel button"),
            style: .cancel,
            handler: { _ in
                handlerCancel?()

            }))

        self.present(alertController, animated: true, completion: nil)
    }
}
