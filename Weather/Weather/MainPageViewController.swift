//
//  MainPageViewController.swift
//  Weather
//
//  Created by Steven Sutana on 11/14/16.
//  Copyright © 2016 Steven Sutana. All rights reserved.
//

import UIKit
import RealmSwift

class MainPageViewController: UIPageViewController {
    var pagecontrol=UIPageControl()
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        var v1 : SingleWeatherViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("SingleWeatherViewController") as! SingleWeatherViewController
        v1.isCheck = true
        v1.view.tag = 0
        return [v1]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        // Do any additional setup after loading the view.        
        //add vc
        weatherPageDelegate = self
        for i in 0..<weatherList!.count {
            let vc : SingleWeatherViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("SingleWeatherViewController") as! SingleWeatherViewController
            vc.view.tag = i+1
            GetDataDelegate(i)
            orderedViewControllers.append(vc)
        }
        
        setViewControllers([orderedViewControllers[0]],
                           direction: .Forward,
                           animated: true,
                           completion: nil)
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func setupUI() {
        let bottomView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT*0.95, width: SCREEN_WIDTH, height: SCREEN_HEIGHT*0.05))
        bottomView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.view.addSubview(bottomView)
        pagecontrol = UIPageControl(frame: CGRect(x:bottomView.frame.size.width/2 - bottomView.frame.size.width*0.3/2, y: bottomView.frame.size.height/2-bottomView.frame.size.height*0.75/2, width: bottomView.frame.size.width*0.3, height: bottomView.frame.size.height*0.75))
        pagecontrol.numberOfPages = weatherList!.count + 1
        pagecontrol.currentPage = 0
        pagecontrol.tintColor = UIColor.whiteColor()
        pagecontrol.pageIndicatorTintColor = UIColor.grayColor()
        pagecontrol.currentPageIndicatorTintColor = UIColor.whiteColor()
        bottomView.addSubview(pagecontrol)
        
        let addWeatherBtn = UIButton(type: .Custom)
        addWeatherBtn.setImage(UIImage(named: "dummyIcon.png"), forState: .Normal)
        addWeatherBtn.contentMode = .ScaleAspectFit
        addWeatherBtn.addTarget(self, action: #selector(self.addWeatherAction), forControlEvents: .TouchUpInside)
        addWeatherBtn.alpha = 0.75
        addWeatherBtn.frame = CGRect(x: bottomView.frame.size.width-bottomView.frame.size.width*0.1, y: bottomView.frame.size.height/2 - bottomView.frame.size.width*0.075/2, width: bottomView.frame.size.width*0.075, height: bottomView.frame.size.width*0.075)
        
        bottomView.addSubview(addWeatherBtn)
    }
    
    //MARK: Action
    
    func addWeatherAction() {
        let addWeatherViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddWeatherViewController") as! AddWeatherViewController
        addWeatherViewController.modalPresentationStyle = .OverFullScreen
        self.presentViewController(addWeatherViewController, animated: true, completion: nil)
    }
}


extension MainPageViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.pagecontrol.currentPage = pageViewController.viewControllers!.first!.view.tag
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let pageContentView = pendingViewControllers[0] as! SingleWeatherViewController
        singleWeatherDelegate = pageContentView
        if (pageContentView.view.tag != 0) {
            GetDataDelegate(pageContentView.view.tag-1)
        }
        self.pagecontrol.currentPage = pageContentView.view.tag
    }
}

extension MainPageViewController : WeatherPageDelegate{
    func AddView() {
        let vc : SingleWeatherViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("SingleWeatherViewController") as! SingleWeatherViewController
        vc.view.tag = orderedViewControllers.count
        pagecontrol.currentPage = orderedViewControllers.count
        pagecontrol.numberOfPages += 1
        
        orderedViewControllers.append(vc)
    }
    
    func SetView(index: Int) {
        
        //because index = 0 always user location
        pagecontrol.currentPage = index + 1
        setViewControllers([orderedViewControllers[index + 1]],
                           direction: .Forward,
                           animated: true,
                           completion: nil)
        
        GetDataDelegate(index)
    }
    
    func DeleteView(index: Int) {
        pagecontrol.numberOfPages = pagecontrol.numberOfPages - 1
        orderedViewControllers.removeAtIndex(index+1)
        for i in 0..<orderedViewControllers.count{
            
            orderedViewControllers[i].view.tag = i
        }
//        orderedViewControllers[index+1].view.tag -= 1
    }
}
