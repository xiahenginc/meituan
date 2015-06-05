//
//  TabIndexTuangouViewController.swift
//  美团
//
//  Created by wxqdev on 15/6/5.
//  Copyright (c) 2015年 meituan.iteasysoft.com. All rights reserved.
//

import UIKit

class TabIndexTuangouViewController: UIViewController {
//,UISearchBarDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var searchBar = UISearchBar()
//        searchBar.delegate = self
//        self.navigationItem.titleView = searchBar

        
        loadurl(initurl)
    }
    
    func loadurl(url:String){
        let requestURL = NSURL(string:url)
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }
    
    
    var initurl = "http://i.meituan.com/"
    var level = 0
    @IBOutlet weak var webView: UIWebView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        println("Search btn clicked")
//        var searchtext = searchBar.text
//        doSearch(searchBar,searchtext:searchtext)
//        // keyboard.endEditing()
//    }
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
//         println("Search btn searchBarTextDidBeginEditing")
//        let dvc  = self.storyboard?.instantiateViewControllerWithIdentifier("webpageview") as! WebPageViewController
//        dvc.navigationController?.title = "搜索"
//        dvc.url = "http://i.meituan.com/s/?cevent=imt%2Fhomepage%2Fsearch"
//        self.navigationController?.pushViewController(dvc, animated: true)
//    }
//    
//    func searchBar(searchBar: UISearchBar,textDidChange searchText: String){
//        
//        doSearch(searchBar,searchtext:searchText)
//    }
//    
//    
//    func doSearch(searchBar: UISearchBar,var searchtext :String){
//        
//        
//    }
//    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
