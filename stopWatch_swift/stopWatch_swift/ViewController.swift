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
    
    var totalTime = 0 {
        willSet{
            timeLable.text = convertTime(seconds: newValue)
        }
    }
    var intervals = 0 {
        willSet{
            let cell = timingCell()
            cell?.detailTextLabel?.text = convertTime(seconds: newValue)
        }

    }
    
    var timer: Timer?
    let data = stopWatchData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        setUI()
    }
    
    @IBAction func reset(_ sender: WSButton) {
        if sender.isSelected {
            
            resetVariables()
            
            sender.isEnabled = false
            sender.isSelected = false
        } else {
            intervals = 0
            data.beginingNewTime()
        }
        
        tableView.reloadData()
    }
    
    func resetVariables(){
        totalTime = 0
        intervals = 0
        data.reset()
    }
    
    @IBAction func start(_ sender: WSButton) {
        sender.isSelected = !sender.isSelected
        
        if !sender.isSelected {
            resetButton.isSelected = true
            timer?.invalidate()
            timer = nil
            return
        }
        
        if data.isReset {
            data.beginingNewTime {
                self.tableView.reloadData()
                self.resetButton.isEnabled = true
            }
        } else {
            resetButton.isSelected = false
        }
        
        if timer == nil {
            timer = Timer.init(timeInterval: 0.01, repeats: true, block: { [weak self] _ in
                self?.totalTime += 1
                self?.intervals += 1
                self?.data.timing(time: self!.intervals)
            })
            RunLoop.current.add(self.timer!, forMode: .commonModes)
        }
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
        return data.times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RecordTimeCell
        
        if cell == nil {
            cell = RecordTimeCell.init(style: .value1, reuseIdentifier: "cell")
        }
        
        cell?.recordTime(with: data, indexPath)
         
        return cell!;
    }
    
    func timingCell()->RecordTimeCell?{
        return tableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as? RecordTimeCell
    }
    
    func convertTime(seconds: Int) ->String{
        return String(format: "%02ld:%02ld.%02ld",seconds / 100 / 60, seconds / 100 % 60, seconds % 100)
    }
}
