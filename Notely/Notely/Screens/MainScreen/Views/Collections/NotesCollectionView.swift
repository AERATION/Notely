import Foundation
import UIKit

protocol NotesCollectionViewDelegate {
    func noteCellProvider(colectionView: UICollectionView, indexPath: IndexPath, note: NoteData) -> UICollectionViewCell?
}

class NotesCollectionView: UICollectionView {
    enum SectionType: Int, CaseIterable {
        case main
    }
    
    var cellProviderDelegate: NotesCollectionViewDelegate
    
    typealias NotesDataSource = UICollectionViewDiffableDataSource<SectionType, NoteData>
    private var notesdataSource: NotesDataSource!
    
    
    init(cellProviderDelegate: NotesCollectionViewDelegate) {
        self.cellProviderDelegate = cellProviderDelegate
        
        super.init(frame: .zero, collectionViewLayout: NotesCollectionView.getListLayout())
        
        configureListCollectionView()
        configureNotesDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureListCollectionView() {
        self.register(NoteCellPrivate.self, forCellWithReuseIdentifier: NoteCellPrivate.reuseIdentifier)
        self.register(NoteCellPublic.self, forCellWithReuseIdentifier: NoteCellPublic.reuseIdentifier)
    }
    
    
    private static  func getListLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(44)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size, repeatingSubitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 16
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func updateNotesSnapshot(with notes: [NoteData]) {
        var snapshot = notesdataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(notes)
        notesdataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureNotesDataSource() {
        notesdataSource = NotesDataSource(collectionView: self, cellProvider: cellProviderDelegate.noteCellProvider)
        
        var snapshot = notesdataSource.snapshot() // current snapshot
        snapshot.appendSections([.main])
        notesdataSource.apply(snapshot, animatingDifferences: true)
    }
}

