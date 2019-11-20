//
//  OnboardingViewController.swift
//  Yaker
//
//  Created by Francisco Barreto on 11/11/2019.
//  Copyright © 2019 Francisco Barreto. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControlBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var getStartedButtonBottomConstraint: NSLayoutConstraint!
    
    
    var scrollWidth: CGFloat = 0.0
    var scrollHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        self.scrollView.delegate = self
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        getStartedButton.layer.cornerRadius = 25
        getStartedButtonBottomConstraint.constant = -60
        
        pageControlBottomConstraint.constant = 80
        
        
        //create the slices and add them
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        for index in 0..<titles.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)
            
            let slide = UIView(frame: frame)
            
            //subviews
            let imageView = UIImageView.init(image: UIImage.init(named: images[index])?.withTintColor(UIColor.white))
            imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            imageView.contentMode = .scaleAspectFit
            imageView.center = CGPoint(x: scrollWidth / 2, y: scrollHeight / 2 )
            
            let title = UILabel.init(frame: CGRect(x:32,y:imageView.frame.maxY+30,width:scrollWidth-64,height:30))
            title.textAlignment = .center
            title.font = UIFont.boldSystemFont(ofSize: 20.0)
            title.text = titles[index]
            title.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            let description = UILabel.init(frame: CGRect(x:32,y:title.frame.maxY+10,width:scrollWidth-64,height:80))
            description.textAlignment = .center
            description.numberOfLines = 3
            description.font = UIFont.systemFont(ofSize: 18.0)
            description.text = descriptions[index]
            description.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            slide.addSubview(imageView)
            slide.addSubview(title)
            slide.addSubview(description)
            scrollView.addSubview(slide)
            
        }
        
        //set width of scrollview to accomodate all the slides
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count), height: scrollHeight)

        //disable vertical scroll/bounce
        self.scrollView.contentSize.height = 1.0

        //initial state
        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0
                        
    }
    
    var titles = ["BE IN THE KNOW", "SHARE YOUR VOICE", "TOTAL ANONYMITY"]
    var descriptions = ["Yaker lets you stay tuned to whats happening around you.", "We order the feed based on popularity, so you will be rewarded for your creative efforts", "Don't worry about being judged , anonymity will protect you."]
    var images = ["dancing", "speaker", "anonymous"]
    
    override func viewDidLayoutSubviews() {
        
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }
    
    func setIndiactorForCurrentPage()  {
        let page = (scrollView?.contentOffset.x)!/scrollWidth
        pageControl?.currentPage = Int(page)
        
        if pageControl.currentPage == 2 {
            getStartedButtonBottomConstraint.constant = 50
            pageControlBottomConstraint.constant = 20
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @IBAction func getStartedButtonTapped(_ sender: Any) {
    }
    

}
