import UIKit

class StartViewModel {
    func process(controller: UINavigationController) {
        DeviceManager.shared.checkDeviceExistence{ _ in
         
            let listC = MyNoteListViewController()
            listC.title = "Мои"
            let listP = PublicNoteListViewController()
            listP.title = "Публичные"
            
            let mainView = MainScreenViewController( [listC, listP] )
            
            controller.pushViewController(mainView, animated: true)
        }
    }
}
