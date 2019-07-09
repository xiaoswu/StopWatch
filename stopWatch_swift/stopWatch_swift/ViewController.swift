//
//  ViewController.swift
//  stopWatch_swift
//
//  Created by ynfMac on 2019/7/8.
//  Copyright © 2019 ynfMac. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var resetButton: WSButton!
    @IBOutlet weak var startButton: WSButton!
    
    var times: [Int]! = []
    var totalTime = 0
    var intervals = 0
    var timer: Timer? = nil
    var isReset = true
    
    var currentRunTimeCell: UITableViewCell? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
    }
    
    @IBAction func reset(_ sender: WSButton) {
        if sender.isSelected {
            isReset = true
            totalTime = 0
            intervals = 0
            
            timeLable.text = "00:00.00"
            if (!times.isEmpty){
                times .removeAll()
            }
            
            tableView.reloadData()
            
            sender.isEnabled = false
            sender.isSelected = false
            
        } else {
            intervals = 0
            addNewTime()
        }
    }
    
    @IBAction func start(_ sender: WSButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            if !resetButton.isEnabled {
                resetButton.isEnabled = true
            } else {
                resetButton.isSelected = false
            }
            
            if isReset {
                addNewTime()
                isReset = false
            }
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {[weak self] _ in
                self?.totalTime += 1
                self?.intervals += 1
                
                self?.timeLable.text = self?.convertTime(seconds: self!.totalTime)
                
                let cell = self?.topcell()
                cell?.detailTextLabel?.text = self?.convertTime(seconds: self!.intervals)
                self?.times[0] = self!.intervals
            })
            RunLoop.current.add(self.timer!, forMode: .common)
        } else {
            resetButton.isSelected = true
            timer?.invalidate()
        }
    }
    
    func addNewTime(){
        times.insert(0, at: 0)
        tableView.reloadData()
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                                   .font:UIFont.systemFont(ofSize: 18)]
        navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    func setUI(){
        resetButton.layer.cornerRadius = resetButton.bounds.size.width * 0.5
        resetButton.layer.masksToBounds = true
        
        resetButton.setTitle("计次", for: .disabled)
        resetButton.isEnabled = false
        resetButton .setBackgroundImage(createImage(UIColor.init(red: 0.08, green: 0.08, blue: 0.08, alpha: 1)), for: .disabled)
        
        resetButton.setTitle("复位", for: .selected);
        resetButton.setTitleColor(UIColor.white, for: .selected)
        resetButton.setBackgroundImage(createImage(UIColor.gray), for: .selected)
        
        resetButton.setTitle("计次", for: .normal)
        resetButton.setBackgroundImage(resetButton.backgroundImage(for: .selected), for: .normal)
        
        // startButton
        startButton.layer.cornerRadius = self.resetButton.bounds.size.width * 0.5;
        startButton.layer.masksToBounds = true;
        
        startButton.setBackgroundImage(createImage(UIColor.init(red: 20 / 255.0, green: 40 / 255.0, blue: 24 / 255.0, alpha: 1)), for: .normal)
    
        startButton.setTitle("启动", for: .normal)
        startButton.setTitleColor(UIColor.init(red: 64 / 255.0, green: 203 / 255.0, blue: 96 / 255.0, alpha: 1), for: .normal)
        
        startButton.setBackgroundImage(createImage(UIColor.init(red: 74 / 255.0, green: 16 / 255.0, blue: 17 / 255.0, alpha: 1)), for: .selected)
        startButton.setTitle("停止", for: .selected)
        startButton.setTitleColor(.red, for: .selected);
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func createImage(_ color: UIColor) -> UIImage{
        let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        }
        
        cell?.backgroundColor = UIColor.black
        
        cell?.textLabel?.textColor = UIColor.white
        cell?.detailTextLabel?.textColor = UIColor.white
        
        cell?.textLabel?.text = "计次\(times.count - indexPath.row)"
        let time = times[indexPath.row]
        cell?.detailTextLabel?.text = convertTime(seconds: time)
        
        if indexPath.row == maxTimeIndex() && indexPath.row != 0 {
            cell?.textLabel?.textColor = UIColor.red
            cell?.detailTextLabel?.textColor = UIColor.red
        }
        
        if indexPath.row == minTimeIndex() && indexPath.row != 0 {
            cell?.textLabel?.textColor = UIColor.green
            cell?.detailTextLabel?.textColor = UIColor.green
        }
        
        return cell!;
    }
    
    
    
    func minTimeIndex() ->Int{
        if times.count <= 2 {
            return 0;
        }
        
        var minIndex = 1
        
        for index in 2..<times.count {
            if(times[index] < times[minIndex]){
                minIndex = index
            }
        }
        return minIndex
    }
    
    func maxTimeIndex() ->Int{
        if times.count <= 2 {
            return 0;
        }
        
        var maxIndex = 1
        
        for index in 2..<times.count {
            if(times[index] > times[maxIndex]){
                maxIndex = index
            }
        }
        return maxIndex
    }
    
    func topcell()->UITableViewCell?{
        return tableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath)
    }
    
    func convertTime(seconds: Int) ->String{
        return String(format: "%02ld:%02ld.%02ld",seconds / 100 / 60, seconds / 100 % 60, seconds % 100)
    }
}
