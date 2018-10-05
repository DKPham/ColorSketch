//
//  DetailViewController.swift
//  ColorSketch
//
//  Created by Duy Pham on 10/5/18.
//  Copyright © 2018 Duy Khac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var pictureImageView: UIImageView!
    var picture: Picture?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = picture?.name
        if let imageData = picture?.image {
            pictureImageView.image = UIImage(data: imageData)
        }
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        if let context = appDelegate?.persistentContainer.viewContext {
            if let pictureToDelete = picture {
                context.delete(pictureToDelete)
                appDelegate?.saveContext()
                navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func sharePressed(_ sender: Any) {
        if let image = pictureImageView.image {
            let shareVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(shareVC, animated: true, completion: nil)
        }
    }

}
