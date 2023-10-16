import Foundation
import UIKit
import SnapKit

class MainScreenViewController: UIViewController {
    private let header: ScreenHeadView = {
        var head = ScreenHeadView()
        return head
    }()
    
    private var segmentViewControllers: [UIViewController] = []
    private var segmentedControl: UISegmentedControl?
    private var lastDisplayedSegmentViewControllerIndex: Int?
    
    public init(_ viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.segmentViewControllers = viewControllers
        self.view.backgroundColor = UR.Color.white
        self.navigationItem.hidesBackButton = true
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(header)
        
        let selectedIndex = 0
        header.delegate = self
        self.segmentedControl = UISegmentedControl(items: segmentTitles())
        self.segmentedControl?.selectedSegmentIndex = selectedIndex
        self.view.addSubview(segmentedControl!)
        segmentedControl!.addTarget(self, action: #selector(segmentSelected), for: .valueChanged)
        
        setupConstraints()
        
        displaySegmentViewController(selectedIndex)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DeviceManager.shared.getUserReference() == nil {
            self.segmentedControl?.setEnabled(false, forSegmentAt: 1)
        } else {
            self.segmentedControl?.setEnabled(true, forSegmentAt: 1)
        }
    }
    
    private func segmentTitles() -> [String] {
        var segmentTitles: [String] = []
        for viewController in self.segmentViewControllers {
            if let title = viewController.title {
                segmentTitles.append(title)
            }
        }
        return segmentTitles
    }
    
    @objc private func segmentSelected(_ segmentControl: UISegmentedControl) {
        var lastDisplayedIndex: Int? = nil
        
        if let i = self.lastDisplayedSegmentViewControllerIndex {
            lastDisplayedIndex = i
        }
        
        displaySegmentViewController(segmentControl.selectedSegmentIndex)
        
        if let j = lastDisplayedIndex {
            hideSegmentViewController(j)
        }
    }
    
    private func displaySegmentViewController(_ segmentViewControllerIndex: Int) {
        let viewController = self.segmentViewControllers[segmentViewControllerIndex]
        
        self.addChild(viewController)
        
        self.view.addSubview(viewController.view)
        
        viewController.view.snp.makeConstraints{ make in
            make.top.equalTo(segmentedControl!.snp.bottom).offset(16)
            make.bottom.trailing.leading.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        viewController.didMove(toParent: self)
        
        self.lastDisplayedSegmentViewControllerIndex = segmentedControl?.selectedSegmentIndex
    }
    
    private func hideSegmentViewController(_ segmentViewControllerIndex: Int) {
        let viewController = self.segmentViewControllers[segmentViewControllerIndex]
        
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
}

extension MainScreenViewController: ScreenHeadViewDelegate {
    func personPressed() {
        if DeviceManager.shared.getUserReference() != nil {
            let profile = ProfileViewController()
            navigationController?.pushViewController(profile, animated: true)
        } else {
            let splash = SplashViewController()
            navigationController?.pushViewController(splash, animated: true)
        }
    }
    
    func actionsPressed() {
        self.present(makeMenuAlert(), animated: true)
    }
    
    func makeMenuAlert() -> UIAlertController {
        let alertMenuController = UIAlertController(title: "Выберите действие", message: nil, preferredStyle: .actionSheet)
        
        let addFolderButton = UIAlertAction(title: "Добавить папку", style: .default) {
            [weak self] action in
            
            let dialogMessage = UIAlertController(title: "Добавить папку", message: "", preferredStyle: .alert)
            // Add text field
            dialogMessage.addTextField(configurationHandler: { textField in
                textField.placeholder = "Название папки"
            })
            
            let cancel = UIAlertAction(title: "отмена", style: .default, handler: { (action) -> Void in
                // self?.dismiss(animated: true)
            })
            
            let add = UIAlertAction(title: "Добавить", style: .default, handler: { (action) -> Void in
                let folderName = dialogMessage.textFields?.first?.text ?? "Noname"
                let _ = FolderManager.shared.createFolder(folder: Folder(name: folderName, notes: 0))
            })
            
            dialogMessage.addAction(cancel)
            dialogMessage.addAction(add)
            
            self!.present(dialogMessage, animated: true)
        }
        
        let sortNotesButton = UIAlertAction(title: "Соритровать по алфавиту", style: .default) {
            //[weak self]
            action in
            
            //            self!.viewModel.notes.sort {
            //                $0.title ?? "" < $1.title ?? ""
            //            }
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertMenuController.addAction(addFolderButton)
        alertMenuController.addAction(sortNotesButton)
        alertMenuController.addAction(cancelButton)
        
        return alertMenuController
    }
    
    
    func changeSegmentControllAvaliblility(value: Bool){
        segmentedControl?.isEnabled = value
    }
    
    private func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        segmentedControl!.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(header.snp.bottom).offset(10)
        }
    }
}

