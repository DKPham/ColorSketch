//
//  PicturesCollectionViewController.swift
//  ColorSketch
//
//  Created by Duy Pham on 10/5/18.
//  Copyright © 2018 Duy Khac. All rights reserved.
//

import UIKit

class PicturesCollectionViewController: UICollectionViewController {

    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadPictures()
    }

    func loadPictures() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let pictures = try? context.fetch(Picture.fetchRequest()) as? [Picture] {
                if let pics = pictures {
                    self.pictures = pics
                    collectionView.reloadData()
                }
            }
        }  
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController {
            if let picture = sender as? Picture {
                detailVC.picture = picture
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PictureCollectionViewCell
        cell.picture = pictures[indexPath.row]
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let picture = pictures[indexPath.row]
        performSegue(withIdentifier: "PicturesToDetail", sender: picture)
    }

}
