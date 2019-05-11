//
//  GuideViewController.swift
//  Week9Tutorial
//
//  Created by Daniel Dz on 9/4/19.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit

class GuideViewController:UIViewController,UIScrollViewDelegate
{
    var numOfPages = 4
    let scrollView = UIScrollView()
    let pages = NSMutableArray()
    let pageControl = UIPageControl()
    
    override func viewDidLoad()
    {
        let frame = self.view.bounds
        //scrollView的初始化
        pageControl.numberOfPages = 4
        
        
        scrollView.frame=self.view.bounds
        scrollView.delegate = self
        scrollView.contentSize=CGSize(width: frame.size.width*CGFloat(numOfPages),height: frame.size.height)
        print("\(frame.size.width*CGFloat(numOfPages)),\(frame.size.height)")
        scrollView.isPagingEnabled=true
        scrollView.showsHorizontalScrollIndicator=false
        scrollView.showsVerticalScrollIndicator=false
        scrollView.scrollsToTop=false
        scrollView.backgroundColor = .white
        
        
        for i in 0..<numOfPages{
            let imgfile = "home1"
            print(imgfile)
            let image = UIImage(named:"\(imgfile)")
            let imgView = UIImageView(image: image)
            imgView.frame=CGRect(x: frame.size.width*CGFloat(i),y: CGFloat(0),
                                 width: frame.size.width,height: frame.size.height)
            scrollView.addSubview(imgView)
        }
        
        
        let pageControlSize = pageControl.sizeThatFits(view.bounds.size)
        pageControl.frame = CGRect(x: 0, y: view.bounds.height - pageControlSize.height, width: view.bounds.width, height: pageControlSize.height)
        pageControl.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        
        self.view.addSubview(scrollView)
        self.pageControl.addTarget(self, action: #selector(self.pageChanged(sender:)), for: UIControl.Event.valueChanged)
        self.view.addSubview(pageControl)
        
        //        scrollView.contentOffset = CGPoint.zero
        //        self.view.addSubview(scrollView)
        
    }
    
    
    
    @objc func pageChanged(sender:AnyObject)
    {
        let xVal = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: xVal, y: 0), animated: true)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        print(pageNumber)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        print("scrolled:\(scrollView.contentOffset)")
        let twidth = CGFloat(numOfPages-1) * self.view.bounds.size.width
        if(scrollView.contentOffset.x > twidth)
        {
            let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let viewController = mainStoryboard.instantiateInitialViewController()!
            
            self.present(viewController, animated: true, completion:nil)
        }
    }
}
