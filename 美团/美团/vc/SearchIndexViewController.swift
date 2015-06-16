//
//  SearchIndexViewController.swift
//  美团
//
//  Created by wxqdev on 15/6/8.
//  Copyright (c) 2015年 meituan.iteasysoft.com. All rights reserved.
//

import UIKit

class SearchIndexViewController: WebBaseViewController ,UISearchBarDelegate{
    var searchBar = UISearchBar()
    override func viewDidLoad() {
        
        myWebView = self.webView
        super.viewDidLoad()
        
        
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        searchBar.placeholder = "搜索商品"
        

        loadurl(url)
        
        var btnSearch = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnSearch.frame = CGRectMake(0, 0, 64, 32);
        btnSearch.setTitle("搜索", forState: UIControlState.Normal)
        //btnSearch.setBackgroundImage(UIImage(named: "fh"), forState: UIControlState.Normal)
        btnSearch.addTarget(self, action: "onClickSearch:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItem = UIBarButtonItem(customView:btnSearch)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    func onClickSearch(sender: UIViewController) {
        var txts = searchBar.text
//txts = "百度"
        if txts == ""{
            url = "http://www.test.com18.cn/grwsj/product.htm"
        }
        else{
            var customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
            if let escapedTxt = txts.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet){
                url = "http://www.test.com18.cn/grwwx/search.jsp?w=\(escapedTxt)"
            }
            else{
                 url = "http://www.test.com18.cn/grwwx/search.jsp?w=\(txts)"               
            }
            println("\(url)")
            
            // url = NSString(format: "http://www.test.com18.cn/grwwx/search.jsp?w=\(txt)") as String
        }

        
        loadurl(url)
        
    }
    
    var url = "http://www.test.com18.cn/grwsj/product.htm"
    var level = 1
    @IBOutlet weak var webView: UIWebView!
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
        func searchBarSearchButtonClicked(searchBar: UISearchBar) {
            println("Search btn clicked")
            searchBar.resignFirstResponder()
    //        var searchtext = searchBar.text
    //        doSearch(searchBar,searchtext:searchtext)
            // keyboard.endEditing()
        }
        func searchBarTextDidBeginEditing(searchBar: UISearchBar){
             println("Search btn searchBarTextDidBeginEditing")
//            let dvc  = self.storyboard?.instantiateViewControllerWithIdentifier("searchindexview") as! SearchIndexViewController
//            dvc.navigationController?.title = "搜索"
//            dvc.url = "http://i.meituan.com/s/?cevent=imt%2Fhomepage%2Fsearch"
//            self.navigationController?.pushViewController(dvc, animated: true)
        }
    
        func searchBar(searchBar: UISearchBar,textDidChange searchText: String){
    
            doSearch(searchBar,searchtext:searchText)
        }
    
    
        func doSearch(searchBar: UISearchBar,var searchtext :String){
            
            if searchtext == ""{
                url = "http://www.test.com18.cn/grwsj/product.htm"
                let requestURL = NSURL(string:url)
                let request = NSURLRequest(URL: requestURL!)
                webView.loadRequest(request)
            }
        }
}
