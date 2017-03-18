//
//  ViewScroll.swift
//  MyPets
//
//  Created by NguyenDucBien on 2/17/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit
protocol DetailImageViewDelegate {
    func numberOfRowInSection() -> Int
    func getImageAt(index: Int) -> UIImage?
    func getCurrentIndex() -> Int
//    func cellForItemAt(index: Int) -> Item
}
class DetailImageView: BasicViewController {
    var items: [Item]!
    var delegate: DetailImageViewDelegate!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    var index: Int!
    let cellId = "Cell"
    var isFirstLoad = false
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        
//        imageView.image = delegate.getImageAt(index: delegate.getCurrentIndex())
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isFirstLoad = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.selectItem(at: IndexPath(row: delegate.getCurrentIndex(), section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
}
extension DetailImageView: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.numberOfRowInSection()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.addSubviews()
        cell.imageView.image = delegate.getImageAt(index: indexPath.row)
        return cell
    }
}
extension DetailImageView: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageView.image = delegate.getImageAt(index: indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isFirstLoad
        {
            let indexToScrollTo = IndexPath(row: delegate.getCurrentIndex(), section: 0)
            self.collectionView.scrollToItem(at: indexToScrollTo, at: .centeredHorizontally, animated: false)
            imageView.image = delegate.getImageAt(index: delegate.getCurrentIndex())
            isFirstLoad = true
        }
    }
}
