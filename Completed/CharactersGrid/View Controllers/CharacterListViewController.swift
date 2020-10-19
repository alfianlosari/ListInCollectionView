//
//  CharacterListViewController.swift
//  CharactersGrid
//
//  Created by Alfian Losari on 10/11/20.
//

import UIKit
import SwiftUI

class CharacterListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var segmentedControl = UISegmentedControl(items: [
        "Inset",
        "Plain",
        "Grouped",
        "Sidebar"
    ])
    let sectionedCharacters: [SectionCharacters]
    
    private var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Character>!
    private var headerRegistration: UICollectionView.SupplementaryRegistration<UICollectionViewListCell>!
    
    private var listAppearance: UICollectionLayoutListConfiguration.Appearance = .insetGrouped
    
    private lazy var listLayout: UICollectionViewLayout = {
        
        return UICollectionViewCompositionalLayout { (section, layoutEnvironment) -> NSCollectionLayoutSection? in
            var listConfig = UICollectionLayoutListConfiguration(appearance: self.listAppearance)
            listConfig.headerMode = .supplementary
            
            return NSCollectionLayoutSection.list(using: listConfig, layoutEnvironment: layoutEnvironment)
        }
    }()
    
    private var selectedCharacters = Set<Character>()
    
    init(sectionedCharacters: [SectionCharacters] = Universe.ff7r.sectionedStubs) {
        self.sectionedCharacters = sectionedCharacters
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        navigationItem.titleView = segmentedControl
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func setupCollectionView() {
        collectionView = .init(frame: view.bounds, collectionViewLayout: listLayout)
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
        
        
        
        cellRegistration = UICollectionView.CellRegistration(
            handler: { (cell: UICollectionViewListCell, _, character: Character) in
                var content = cell.defaultContentConfiguration()
                content.text = character.name
                content.secondaryText = character.job
                content.image = UIImage(named: character.imageName)

                content.imageProperties.maximumSize = .init(width: 60, height: 60)
                content.imageProperties.cornerRadius = 30
                
                cell.contentConfiguration = content
    
                
                if self.selectedCharacters.contains(character) {
                    cell.accessories = [.checkmark(), .disclosureIndicator()]
                } else {
                    cell.accessories = [.disclosureIndicator()]
                }
            })
        
        headerRegistration = UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader, handler: { (header: UICollectionViewListCell, _, indexPath) in
            let section = self.sectionedCharacters[indexPath.section]
            var content = header.defaultContentConfiguration()
            content.text = section.headerTitleText
            header.contentConfiguration = content
        })
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            listAppearance = .insetGrouped
        case 1:
            listAppearance = .plain
        case 2:
            listAppearance = .grouped
        default:
            listAppearance = .sidebar
        }
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

extension CharacterListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionedCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sectionedCharacters[section].characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sectionedCharacters[indexPath.section].characters[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sectionedCharacters[indexPath.section].characters[indexPath.item]
        if selectedCharacters.contains(item) {
            selectedCharacters.remove(item)
        } else {
            selectedCharacters.insert(item)
        }
        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
}

struct CharacterListViewControllerRepresentable: UIViewControllerRepresentable {
    
    let sectionedCharacters: [SectionCharacters]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        UINavigationController(rootViewController: CharacterListViewController(sectionedCharacters: sectionedCharacters))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
}

struct CharacterList_Previews: PreviewProvider {
    
    static var previews: some View {
        CharacterListViewControllerRepresentable(sectionedCharacters: Universe.ff7r.sectionedStubs)
            .edgesIgnoringSafeArea(.vertical)
    }
    
}
