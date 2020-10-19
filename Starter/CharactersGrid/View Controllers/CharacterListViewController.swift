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
    // Todo: Add cell and header registration, appearance properties
    
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
        // Todo: Setup Collection View, Layout, and Cell Registration
    }
    
    
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        // Todo: Handle List Style Appearance Changes
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
