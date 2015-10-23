//
//  ViewController.swift
//  UITableViewDemo
//
//  Created by 王卓 on 15/10/13.
//  Copyright © 2015年 BubbleTeam. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let reuseIdentifier="reuseIdentifier"
    let myRefreshControl = UIRefreshControl()
    var reRefreshTime:String?
    
    var infoArray = [item](){
        didSet{
            (sectionArray,numberOfCellInSectionArray)=searchForSection(infoArray)
        }
    }
    var sectionArray = [String]()
    var numberOfCellInSectionArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //为myRefreshControl添加一个ValueChanged事件refreshHeader
        myRefreshControl.addTarget(self, action: "refreshHeader", forControlEvents: UIControlEvents.ValueChanged)
        //修改下拉刷新标题
        myRefreshControl.attributedTitle = NSAttributedString(string: "下拉立即刷新\n")
        if let time = reRefreshTime {
        myRefreshControl.attributedTitle = NSAttributedString(string: "下拉立即刷新\n上次刷新时间:\(time)")
        }
        tableView.addSubview(myRefreshControl)
        self.tableView.footer = MJRefreshAutoNormalFooter(refreshingBlock: refreshFooter)
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    func refreshFooter(){
        
        self.tableView.reloadData()
        self.tableView.footer.endRefreshing()
    }
    
    func refreshHeader(){
        //ProgressHUD.show("wait")
        reRefreshTime = getTime()
        infoArray.append(item(Name: "Hi"))
        if infoArray.count>5{
            infoArray.append(item(Name: "你好"))
        }
        tableView.reloadData()
        if let time = reRefreshTime {
            myRefreshControl.attributedTitle = NSAttributedString(string: "下拉立即刷新   上次刷新时间:\(time)")
        }
        myRefreshControl.endRefreshing()
    }
    /**
    获取当前时间
    
    - returns: 当前时间
    */
    func getTime()->String{
    let Date:NSDate = NSDate(timeIntervalSinceNow:NSDate().timeIntervalSinceNow)
    let formatter = NSDateFormatter()
    formatter.dateFormat = "HH时mm分ss秒"
    let date = formatter.stringFromDate(Date)
    return date;
    }
    
    
//    func tableViewRefreshHeader(){
//        self.tableView.header.lastUpdatedTimeKey = NSDate().description
//        self.tableView.header.endRefreshing()
//    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numberOfCellInSectionArray.count != 0{
            return numberOfCellInSectionArray[section]
        }
        else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as!myTableViewCell
        cell.name.text = "\(infoArray[indexPath.row]) 第\(indexPath.row)个cell"
        cell.img.image=UIImage(named: "TS")
        return cell
    }
    
    //索引数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionArray.count
    }
    
    //Section的标题
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
    }
    
    //获取储存索引的数组
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sectionArray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    根据UITableView Data数组寻找索引并添加进索引数组
    
    - parameter DataArray: UITableView数据数组
    
    - returns: （索引数组,section内cell数量数组）
    */
    func searchForSection(DataArray:[item])->([String],[Int]){
        var stringDataArray = [String]()
        var sectionArray = [String]()
        var numberOfCellInSectionArray = [Int]()
        //获取Title数组
        for var i=0;i<DataArray.count;++i{
            stringDataArray.append(String((DataArray[i].Name!)[(DataArray[i].Name!).startIndex]))
        }
        for var index=0;index<stringDataArray.count;++index{
            sectionArray.append(stringDataArray[index])
            var count = 1;
            for var j=index+1;j<stringDataArray.count;++j{
                if stringDataArray[j] == stringDataArray[index]{
                    count++;
                    stringDataArray.removeAtIndex(j)
                    //删除一个之后回到上一个元素
                    --j;
                }
            }
            numberOfCellInSectionArray.append(count)
        }
        return (sectionArray,numberOfCellInSectionArray)
    }
}

