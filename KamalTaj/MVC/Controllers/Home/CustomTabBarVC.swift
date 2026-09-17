//
//  CustomTabBarVC.swift
//  Internacia
//
//  Created by Admin on 19/10/22.
//

import UIKit

//
//  HomeTabBarVC.swift
//  Hoetus
//
//  Created by Rahul on 19/02/24.
//

import UIKit

class HomeTabBarVC: UITabBarController {
    
    //MARK: - LifeCycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newTabBarHeight: CGFloat = 75
        var tabBarFrame = tabBar.frame
        tabBarFrame.size.height = newTabBarHeight
        tabBarFrame.origin.y = view.frame.height - newTabBarHeight
        tabBar.frame = tabBarFrame

        if let items = tabBar.items {
            let font = UIFont(name: "Poppins-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: font,
                        .foregroundColor: UIColor.gray,
                        .kern: 0
                    ]
                    
                    let selectedAttributes: [NSAttributedString.Key: Any] = [
                        .font: font,
                    ]
            for item in items {
                if let originalImage = item.image {
                    item.image = originalImage.resize(to: CGSize(width: 24, height: 24))
                    item.selectedImage = originalImage.resize(to: CGSize(width: 24, height: 24))
                }

                // Adjust title position
                item.setTitleTextAttributes(attributes, for: .normal)
                item.setTitleTextAttributes(selectedAttributes, for: .selected)
                item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)

                // Adjust image position
                item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
                print(item.image?.size )
            }
        }
        print(tabBar.frame.size)

        //        configureBlurBackground()
//        let customTabBar = CustomTabBar()
//        setValue(customTabBar, forKey: "tabBar")
        tabBar.layer.shadowColor = UIColor.init(hexString: "#d4d4d4").cgColor
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2) // Negative for top shadow
        tabBar.layer.shadowRadius = 10
        tabBar.layer.masksToBounds = false
        tabBar.backgroundColor = UIColor.white// opacity
        self.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        configureBlurBackground()
    }
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            // Adjust the height of the tab bar
        }
    
    

}
extension HomeTabBarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            if index == 1 || index == 4{
                // Check if user is logged in
                if !isLoggedIn() {
                    let alertController = UIAlertController(title: "Login Required", message: "Please log in to access My Bookings.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    tabBarController.present(alertController, animated: true, completion: nil)
                    
                    return false
                }
            }else if  index == 2 || index == 3 {
                if !isLoggedIn(){
                    let alertController = UIAlertController(title: "Login Required", message: "Please log in to access Profile.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    tabBarController.present(alertController, animated: true, completion: nil)
                    return false
                }
            }
        }
        return true
    }
    //    MARK: - Helper
    
    func isLoggedIn() -> Bool {
        
        if "".getUserId().isEmpty {
            return false
        }
        return true
    }
}


class CustomTabBar: UITabBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.shadowColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.1).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: -2) // Negative Y for top shadow
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor.white // 45% opacity
    }
}
extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
