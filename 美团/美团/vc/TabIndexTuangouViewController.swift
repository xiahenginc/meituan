//
//  TabIndexTuangouViewController.swift
//  美团
//
//  Created by wxqdev on 15/6/5.
//  Copyright (c) 2015年 meituan.iteasysoft.com. All rights reserved.
//

import UIKit

class TabIndexTuangouViewController: UIViewController,UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        searchBar.placeholder = "搜索商品"
        
        loadurl(initurl)
    }
    
    func loadurl(url:String){
        let requestURL = NSURL(string:url)
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }
    
    //首页
    var initurl = "http://www.test.com18.cn/grwsj/"
    var level = 0
    @IBOutlet weak var webView: UIWebView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool{
        let dvc  = self.storyboard?.instantiateViewControllerWithIdentifier("searchindexview") as! SearchIndexViewController
        dvc.navigationController?.title = "搜索"
        //dvc.url = "http://www.test.com18.cn/grwsj/product.htm"
        self.navigationController?.pushViewController(dvc, animated: true)
        return false
    }

//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        println("Search btn clicked")
//        searchBar.resignFirstResponder()
////        var searchtext = searchBar.text
////        doSearch(searchBar,searchtext:searchtext)
//        // keyboard.endEditing()
//    }
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
//         println("Search btn searchBarTextDidBeginEditing")
//        let dvc  = self.storyboard?.instantiateViewControllerWithIdentifier("searchindexview") as! SearchIndexViewController
//        dvc.navigationController?.title = "搜索"
//        dvc.url = "http://i.meituan.com/s/?cevent=imt%2Fhomepage%2Fsearch"
//        self.navigationController?.pushViewController(dvc, animated: true)
//    }
    
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
