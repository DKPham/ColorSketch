//
//  DrawViewController.swift
//  ColorSketch
//
//  Created by Duy Pham on 10/4/18.
//  Copyright © 2018 Duy Khac. All rights reserved.
//

import UIKit
import ChromaColorPicker

class DrawViewController: UIViewController, ChromaColorPickerDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var drawingImageView: UIImageView!
    
    var lastPoint : CGPoint = CGPoint(x: 0, y: 0)
    var currentColor = UIColor.blue.cgColor
    var brushSize : Float = 10.0
    var colorPicker : ChromaColorPicker?
    var colorPickerBackgroundView = UIView()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorPickerBackgroundView = UIView(frame: view.frame)
        colorPickerBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        view.addSubview(colorPickerBackgroundView)
        
        colorPicker = ChromaColorPicker(frame: CGRect(x: view.frame.size.width / 2 - 100, y: view.frame.size.height / 2 - 100, width: 200, height: 200))
        if let picker = colorPicker {
            picker.delegate = self
            picker.padding = 5
            picker.stroke = 3
            picker.hexLabel.isHidden = true
            view.addSubview(picker)
        }

        colorPicker?.isHidden = true
        colorPickerBackgroundView.isHidden = true
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func colorPressed(_ sender: Any) {
        colorPicker?.adjustToColor(UIColor(cgColor: currentColor))
        colorPicker?.isHidden = false
        colorPickerBackgroundView.isHidden = false
    }
    
    @IBAction func sizePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Brush Size", message: "\n\n\n\n\n", preferredStyle: .alert)
        let slider = UISlider(frame: CGRect(x: 10, y: 50, width: 250, height: 80))
        slider.minimumValue = 1
        slider.maximumValue = 100
        slider.value = brushSize
        alert.view.addSubview(slider)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.brushSize = slider.value
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func eraserPressed(_ sender: Any) {
        currentColor = UIColor.white.cgColor
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Save Picture", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Name your picture"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let name = alert.textFields?.first?.text {
                if name != "" {
                    if let context = self.appDelegate?.persistentContainer.viewContext {
                        let picture = Picture(context: context)
                        picture.name = name
                        if let image = self.drawingImageView.image {
                            picture.image = image.jpegData(compressionQuality: 1)
                            self.appDelegate?.saveContext()
                        }
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Finger down")
        stackView.isHidden = true
        if let beginPoint = touches.first?.location(in: drawingImageView) {
            lastPoint = beginPoint
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Moved")
        if let movedPoint = touches.first?.location(in: drawingImageView) {
            drawBetweenTwoPoints(p1: lastPoint, p2: movedPoint)
            lastPoint = movedPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Finger Off")
        stackView.isHidden = false
        if let endPoint = touches.first?.location(in: drawingImageView) {
            drawBetweenTwoPoints(p1: lastPoint, p2: endPoint)
        }
    }

    func drawBetweenTwoPoints(p1: CGPoint, p2: CGPoint) {
        UIGraphicsBeginImageContext(drawingImageView.frame.size)
        drawingImageView.image?.draw(in: CGRect(x: 0, y: 0, width: drawingImageView.frame.size.width, height: drawingImageView.frame.size.height))
        if let context = UIGraphicsGetCurrentContext() {
            context.move(to: p1)
            context.addLine(to: p2)
            context.setLineWidth(CGFloat(brushSize))
            context.setLineCap(.round)
            context.setStrokeColor(currentColor)
            context.strokePath()
            drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
    }
    
    //MARK: - Chroma Color Picker Delegate Methods
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        currentColor = color.cgColor
        colorPicker.isHidden = true
        colorPickerBackgroundView.isHidden = true
    }
    
}
