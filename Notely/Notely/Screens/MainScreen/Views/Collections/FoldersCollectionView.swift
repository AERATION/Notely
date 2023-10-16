import Foundation
import UIKit

class FoldersCollectionView: UICollectionView {
    enum SectionType: Int, CaseIterable {
        case main
    }
    typealias FoldersDataSource = UICollectionViewDiffableDataSource<SectionType, Folder>
    private var foldersdataSource: FoldersDataSource!
    
    init() {
        
        super.init(frame: .zero, collectionViewLayout: FoldersCollectionView.getGridLayout())
        
        configureGridCollectionView()
        configureFoldersDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureGridCollectionView() {
        self.register(FolderCell.self, forCellWithReuseIdentifier: FolderCell.reuseIdentifier)
    }
    
    private static func getGridLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(0.5),
            heightDimension: NSCollectionLayoutDimension.estimated(140)
        )
        
        let sizeg = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(140)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: sizeg, repeatingSubitem: item, count: 2)
        
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 16
        
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    public func updateFoldersSnapshot(with notes: [Folder]) {
        var snapshot = foldersdataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(notes)
        foldersdataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureFoldersDataSource() {
        foldersdataSource = FoldersDataSource(collectionView: self, cellProvider: { (collectionView, indexPath, folder) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.reuseIdentifier,
                                                                for: indexPath) as? FolderCell else {
                fatalError("could not dequeue an ImageCell")
            }
            cell.folderObject = folder
            
            return cell
        })
        
        var snapshot = foldersdataSource.snapshot() // current snapshot
        snapshot.appendSections([.main])
        foldersdataSource.apply(snapshot, animatingDifferences: true)
    }
}
