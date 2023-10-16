import Foundation
import UIKit


class UR {
    
    class Color {
        static let black = UIColor(named: "black")
        static let superDrakGray = UIColor(named: "super-dark-gray")
        static let darkGray = UIColor(named: "dark-gray")
        static let gray = UIColor(named: "gray")
        static let lightGray = UIColor(named: "light-gray")
        static let superLightGray = UIColor(named: "super-light-gray")
        static let white = UIColor(named: "white")
        static let blue = UIColor(named: "blue")
        static let darkBlue = UIColor(cgColor: CGColor(red: 0, green: 0.48, blue: 1.28, alpha: 1))
        static let green = UIColor(named: "green")
        static let red = UIColor(named: "red")
        static let lightRed = UIColor(named: "light-red")
    }
    
    class Font {
        static let largeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
        static let smallTitle = UIFont.systemFont(ofSize: 20, weight: .medium)
        static let noteText = UIFont.systemFont(ofSize: 20)
        
        // TODO: придумать названия
        static let main17Semibold = UIFont.systemFont(ofSize: 17,weight: .semibold)    // .normal
        static let main17 = UIFont.systemFont(ofSize: 17)    // .normal
        static let main15 = UIFont.systemFont(ofSize: 15)    // .normal
        static let main14 = UIFont.systemFont(ofSize: 14)    // .normal
        static let main13 = UIFont.systemFont(ofSize: 13)    // .normal
    }
    
    struct Icons {
        static let lockIcon = UIImage(named: "lock.svg")
        static let folderIcon = UIImage(named: "folder.svg")
        static let smallFolderIcon = UIImage(named: "folder-small.svg")
        static let dotsIcon = UIImage(named: "Union.svg")
        static let personIcon = UIImage(named: "person.circle.fill.svg")
        static let roundDotsIcon = UIImage(named: "ellipsis.circle.fill.svg")
        
        static let folderVeiw = UIImage(named: "folders-view.svg")
        static let folderVeiwSelected = UIImage(named: "folders-view-selected.svg")
        static let noteIcon = UIImage(named: "note-icon.svg")
        static let newNoteIcon = UIImage(named: "plus.circle.fill.svg")
    }
    
    struct Constants {
        static let cornerRadius = CGFloat(11)
    }
}
