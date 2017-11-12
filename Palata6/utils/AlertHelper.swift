import UIKit
import Foundation

class AlertHelper {
    
    class func showErrorAlert(controller: UIViewController, message: String?) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func showFailureAlert(controller: UIViewController, message: String?) {
        let alert = UIAlertController(title: "Неуспешно", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func showSuccessAlert(controller: UIViewController, message: String?) {
        let alert = UIAlertController(title: "Успешно", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }

}
