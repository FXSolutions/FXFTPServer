//
//  ViewController.swift
//  FXFTPServer
//
//  Created by kioshimafx on 2/2/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UITableViewController {
    
    var ftpServer : FtpServer!
    var ipAddress : UILabel!
    var rootDir : String!
    var files = [AnyObject]()
    

    override func loadView() {
        super.loadView()
        
        self.ipAddress = UILabel()
        self.ipAddress.textColor = UIColor.whiteColor()
        self.ipAddress.font = UIFont.systemFontOfSize(14)
        self.ipAddress.numberOfLines = 0
        self.view.addSubview(self.ipAddress)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "FXFTPServer"
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "groupcell")
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        
        self.view.backgroundColor = UIColor ( red: 0.8304, green: 0.8304, blue: 0.8304, alpha: 0.851508620689655 )
        
        startFTPServerOnPort1337()
        
        didReceiveFileListChanged()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.ipAddress.frame = CGRectMake(self.view.frame.size.width/2-100, 80, 200, 30)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func startFTPServerOnPort1337() {
        
        let baseDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        
        self.rootDir = baseDir
        
        self.ftpServer = FtpServer(port: 1337, withDir: baseDir, notifyObject: self)
        
        let ipAddresText = NetworkController.localWifiIPAddress()
        
        self.ipAddress.text = "Connect to \(ipAddresText):1337"
        print("\(ipAddresText):1337")
        
    }
    
    func didReceiveFileListChanged() {
        
        self.files = [AnyObject]()
        
        let filemanager:NSFileManager = NSFileManager()
        let filesFromDir = filemanager.enumeratorAtPath(self.rootDir)

        self.files = (filesFromDir?.allObjects)!
        
        self.tableView.reloadData()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("groupcell", forIndexPath: indexPath) as UITableViewCell
        
        let cell : UITableViewCell =  UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "groupcell")
        
        let object = self.files[indexPath.row]
        
        
        if (NSFileManager.defaultManager().fileExistsAtPath("\(self.rootDir)/\(object)")) {
            
            let mp3path = "\(self.rootDir)/\(object)"
            let mp3url = NSURL(fileURLWithPath: mp3path)
            let audioAsset = AVURLAsset(URL: mp3url)
            let audioDuration = audioAsset.duration
            let durationInSeconds = Int(CMTimeGetSeconds(audioDuration))
            var kbps :Double!
            
            
            do {
                
                let attr : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(mp3path)
                
                var fileSize : UInt64 = 0
                
                if let _attr = attr {
                    fileSize = _attr.fileSize();
                }
                print("File size = \(fileSize)")
                
                let kbit = Int(fileSize)/128;//calculate bytes to kbit
                kbps = ceil(round(Double(kbit)/Double(durationInSeconds))/16)*16
                
                
            } catch {
                
            }
            
            getAtristNameFromAsset(audioAsset, comptition: { (title) -> () in
                cell.textLabel?.text = "\(object) : \(kbps)"
                cell.detailTextLabel?.text = "\(title)"
            })
            
            
        }
        
        return cell
        
    }
    
    
    
    func getAtristNameFromAsset(asset:AVURLAsset,comptition:(title:String) -> ()) {
        
        var artist = ""
        var title  = ""
        
        for (_, format) in asset.availableMetadataFormats.enumerate() {
            for (_, item) in asset.metadataForFormat(format).enumerate() {
                
                print("commonKey === \(item.commonKey)")
                
                if item.commonKey == "artist" {
                    artist = item.value as! String
                } else if item.commonKey == "title" {
                    title = item.value as! String
                }
                
                if (artist != "" && title != "") {
                    print("artist/ title === \(artist) - \(title)")
                    comptition(title: "\(artist) - \(title)")
                    break;
                }
                
            }
            
        }
        
        
        
        
    }
    
    
    
}

