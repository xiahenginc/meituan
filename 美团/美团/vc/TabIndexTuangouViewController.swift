//
//  TabIndexTuangouViewController.swift
//  美团
//
//  Created by wxqdev on 15/6/5.
//  Copyright (c) 2015年 meituan.iteasysoft.com. All rights reserved.
//

import UIKit

class TabIndexTuangouViewController: WebBaseViewController,UISearchBarDelegate {

    override func viewDidLoad() {
        myWebView = self.webView
        super.viewDidLoad()
       
        
        var searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        searchBar.placeholder = "搜索商品"
        
       
        loadurl(initurl)
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



}
