//
//  AdminReviewsTVCell.swift
//  Hoetus
//
//  Created by Rahul Adsure on 01/04/24.
//

import UIKit
import WebKit

class AdminReviewsTVCell: UITableViewCell {

    @IBOutlet weak var img_review: UIImageView!
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_rating: FloatRatingView!
    
    @IBOutlet weak var lbl_ratingCount: UILabel!
    @IBOutlet weak var web_view: WKWebView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadSVGFromURL(url: String) {
        // URL of the SVG content
        guard let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            return
        }

        // Fetch SVG content from URL
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching SVG content:", error?.localizedDescription ?? "Unknown error")
                return
            }

            // Convert data to string
            if let svgContent = String(data: data, encoding: .utf8) {
                // Embed SVG content within HTML
                let htmlString = """
                <html>
                <head>
                    <style>
                        body { margin: 0; padding: 0; }
                        svg { display: block; max-width: 16%; height: auto; border: 1px solid black; border-radius: 5px;}
                    </style>
                </head>
                <body>
                    \(svgContent)
                </body>
                </html>
                """

                // Load HTML string into WebView
                DispatchQueue.main.async {
                    self?.web_view.loadHTMLString(htmlString, baseURL: nil)
                }
            } else {
                print("Error converting SVG content to string")
            }
        }

        // Start the data task
        task.resume()
    }

}
