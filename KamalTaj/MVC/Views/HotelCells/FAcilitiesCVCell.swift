//
//  FAcilitiesCVCell.swift
//  Hoetus
//
//  Created by Rahul on 28/02/24.
//

import UIKit
import WebKit

class FAcilitiesCVCell: UICollectionViewCell {
    
    @IBOutlet weak var lbl_facility: UILabel!
    @IBOutlet weak var img_facility: UIImageView!
    @IBOutlet weak var web_view: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        web_view.isHidden = true
        img_facility.isHidden = false
    }
    func loadImageFromURL(url: String) {
        guard let imageUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            print("Invalid URL.")
            return
        }
        
        // Determine if the URL is for an SVG or PNG file based on its extension
        if imageUrl.pathExtension.lowercased() == "svg" {
            loadSVGFromURL(url: imageUrl)
        } else {
            loadPNGFromURL(url: imageUrl)
        }
    }
    
    private func loadSVGFromURL(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching SVG content:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            // Convert data to string
            if let svgContent = String(data: data, encoding: .utf8) {
                // Embed SVG content within HTML
                let htmlString = """
                    <!DOCTYPE html>
                    <html>
                    <head>
                        <style>
                            body {
                                margin: 0;
                                padding: 0;
                                display: flex;
                                justify-content: center;
                                align-items: center;
                                width: 100vw;
                                height: 100vh;
                                overflow: hidden;
                            }
                            .svg-container {
                                width: 100px;
                                height: 100px;
                                display: flex;
                                justify-content: center;
                                align-items: center;
                                overflow: hidden;
                            }
                            .svg-container svg {
                                width: 100%;
                                height: 100%;
                            }
                        </style>
                    </head>
                    <body>
                        <div class="svg-container">
                            \(svgContent)
                        </div>
                    </body>
                    </html>
                    """
                // Load HTML string into WebView
                DispatchQueue.main.async {
                    self?.web_view.isHidden = false
                    self?.img_facility.isHidden = true
                    self?.web_view.loadHTMLString(htmlString, baseURL: nil)
                }
            } else {
                print("Error converting SVG content to string")
            }
        }
        task.resume()
    }
    
    private func loadPNGFromURL(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching PNG content:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            // Create UIImage from data
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.web_view.isHidden = true
                    self?.img_facility.isHidden = false
                    self?.img_facility.image = image
                }
            } else {
                print("Error converting PNG data to image.")
            }
        }
        task.resume()
    }
}
