//
//  FirstViewController.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 14/03/1442 AH.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    private let scrollView =  UIScrollView()
    
    private let img: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "square.and.pencil")
        img.tintColor = UIColor.pink
        img.frame = CGRect(x: 150, y: 100, width: 100, height: 100)
        return img
    }()
    
    private let img2: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "logo")
        img.tintColor = UIColor.purple
        img.frame = CGRect(x: 150, y: 100, width: 100, height: 100)
        return img
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Organize your works"
        label.textColor = .purpleBlueish
        label.textAlignment = .center
        label.font = UIFont(name: "Hiragino Sans W3", size: 30)
        return label
    }()
    
    private let subwelcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's organaize your works with priority and do everything without stress"
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Hiragino Sans W3", size: 20)
        return label
    }()
    
    private let welcomeLabel1: UILabel = {
        let label = UILabel()
        label.text = "Welcome To Taskly"
        label.textColor = .purpleBlueish
        label.textAlignment = .center
        label.font = UIFont(name: "Hiragino Sans W3", size: 30)
        return label
    }()
    
    private let subwelcomeLabel1: UILabel = {
        let label = UILabel()
        label.text = "Create an account to save all your tasks and access them from anywhere"
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Hiragino Sans W3", size: 20)
        return label
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.pageIndicatorTintColor = UIColor.systemGray4
        pageControl.currentPageIndicatorTintColor = UIColor.pink
        return pageControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") == true {
            let storyboard = UIStoryboard(name: "Tasks", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "home") as! HomeViewController
//            self.navigationController?.pushViewController(mainTabBarController, animated: false)
            mainTabBarController.modalPresentationStyle = .fullScreen
            self.present(mainTabBarController, animated: true, completion: nil)
        }
        scrollView.delegate = self
        button.layer.cornerRadius  = 13
        button1.layer.cornerRadius = 13
        button2.layer.cornerRadius = 13
        button.layer.borderWidth   = 0.8
        button.layer.borderColor   = UIColor.lightGray.cgColor
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 380).isActive = true
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20).isActive = true
        
        pageControl.addTarget(self, action: #selector(pageControlerDidChange(_:)), for: .valueChanged)
    }
    
    @objc private func pageControlerDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        let x = CGFloat(current) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if scrollView.subviews.count == 2 {
            configureScrollViews()
        }
    }
    
    func configureScrollViews() {
        
        scrollView.contentSize = CGSize(width: view.frame.size.width*2, height: scrollView.frame.size.height)
        
        let imgs: [UIImageView] = [img2, img]
        let label: [UILabel]    = [welcomeLabel1, welcomeLabel]
        let subLabel: [UILabel] = [subwelcomeLabel1, subwelcomeLabel]
        scrollView.isPagingEnabled = true
        
        for i in 0..<2 {
            
            // MARK: - Creating view
            let page = UIView(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: 0, width: view.frame.size.width, height: scrollView.frame.size.height))
            page.addSubview(imgs[i])
            
            // MARK: - Main Label constraints
            label[i].translatesAutoresizingMaskIntoConstraints = false
            page.addSubview(label[i])
            
            label[i].heightAnchor.constraint(equalToConstant: 40).isActive = true
            label[i].leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 30).isActive = true
            label[i].trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: -30).isActive = true
            label[i].topAnchor.constraint(equalTo: imgs[i].bottomAnchor, constant: 20).isActive = true
            
            // MARK: - Sub Label constraints
            subLabel[i].translatesAutoresizingMaskIntoConstraints = false
            page.addSubview(subLabel[i])
            subLabel[i].heightAnchor.constraint(equalToConstant: 60).isActive = true
            subLabel[i].leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 10).isActive = true
            subLabel[i].trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: -10).isActive = true
            subLabel[i].topAnchor.constraint(equalTo: label[i].bottomAnchor, constant: 30).isActive = true
            scrollView.addSubview(page)
        }
    }
    
    @IBAction func Button1(_ sender: UIButton) {
        print("j")
    }
}

extension FirstViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floor(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
}

