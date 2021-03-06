//
//  DetailViewController.swift
//  Project1
//
//  Created by Ma Xueyuan on 2020/01/07.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: String?
    var viewTitle: String?
    @IBOutlet weak var timesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewTitle
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            DispatchQueue.global(qos: .userInitiated).async {
                let image = UIImage(named: imageToLoad)
                DispatchQueue.main.async { [unowned self] in
                    self.imageView.image = image
                }
            }
        }
        
        var times = UserDefaults.standard.integer(forKey: selectedImage!)
        times += 1
        UserDefaults.standard.set(times, forKey: selectedImage!)
        timesLabel.text = "Viewd \(times) times"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let originImage = imageView.image else {
            print("No image found")
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1024, height: 768))
        let img = renderer.image { ctx in
            originImage.draw(at: CGPoint(x: 0, y: 0))
            
            let source = "From Storm Viewer"
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 36), .paragraphStyle: paragraphStyle, .foregroundColor: UIColor.white]
            let attributedSource = NSAttributedString(string: source, attributes: attrs)
            attributedSource.draw(with: CGRect(x: 0, y: 700, width: 1024, height: 68), options: .usesLineFragmentOrigin, context: nil)
        }

        let vc = UIActivityViewController(activityItems: [selectedImage ?? "", img.jpegData(compressionQuality: 0.8)!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
