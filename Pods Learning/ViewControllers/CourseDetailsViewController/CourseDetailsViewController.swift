//
//  CourseDetailsViewController.swift
//  Pods Learning
//
//  Created by kamlesh on 03/09/20.
//  Copyright © 2020 kamlesh. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import SDWebImage
import AVFoundation
import AVKit

class CourseDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var strCourseName = ""
    var strCourseImage = ""
    var strDescription = ""
    var strDocumentKeyID = ""
    var arrEnrolledUsers : [String] = []
    
    var allChapterData : [chapterDetails] = []
    
    let playerViewController = MYVideoController()
    
    let userId = Auth.auth().currentUser?.uid
    
    fileprivate lazy var userIsEnrolled = false
    
    lazy var courseImageView : UIImageView = {
       let image = UIImageView()
       return image
    }()
    
    lazy var lblTitleDescription : UILabel = {
       let title = UILabel()
        title.font = UIFont(name: "HelveticaNeue-MediumItalic", size: 15)
        title.textColor = .black
        title.text = "Description"
       return title
    }()
    
    lazy var lblDescription : UILabel = {
       let title = UILabel()
        title.font = UIFont(name: "HelveticaNeue-Italic", size: 12)
        title.numberOfLines = 4
        title.textColor = .darkGray
       return title
    }()
    
    lazy var btnEnrollNow : UIButton = {
       let button = UIButton()
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.backgroundColor = UIColor.init(red: 81/255, green: 152/255, blue: 114/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(btnEnrollNowPressed), for: .touchUpInside)
        button.setTitle("Enroll Now", for: .normal)
       return button
    }()

    lazy var tblViewChapterDetials : UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    
    lazy var lblTitleChapter : UILabel = {
      let name = UILabel()
      name.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
      name.textColor = .black
      name.text = "Chapters"
      return name
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.hidesWhenStopped = true
        loader.style = .gray
        loader.color = .gray
        return loader
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = strCourseName
        self.navigationItem.hidesBackButton = false
        
        tblViewChapterDetials.rowHeight = 70
        
        tblViewChapterDetials.register(ChapterDetailsTableViewCell.self, forCellReuseIdentifier: "ChapterDetailsTableViewCell")
        
        tblViewChapterDetials.backgroundColor = .clear
        tblViewChapterDetials.delegate = self
        tblViewChapterDetials.dataSource = self
        
        view.backgroundColor = .white
        view.addSubview(courseImageView)
        view.addSubview(lblDescription)
        view.addSubview(lblTitleDescription)
        view.addSubview(btnEnrollNow)
        view.addSubview(lblTitleChapter)
        view.addSubview(tblViewChapterDetials)
        view.addSubview(activityIndicator)
        
        print(arrEnrolledUsers)
        
        let imageURL = URL(string: strCourseImage)
        
        if arrEnrolledUsers.contains(userId!) {
            userIsEnrolled = true
            btnEnrollNow.isHidden = true
        }else{
            userIsEnrolled = false
            btnEnrollNow.isHidden = false
        }
        courseImageView.sd_setImage(with: imageURL)
        lblDescription.text = strDescription
        
        AutoLayoutForAllViews()
        fetchAllChapterDetails()
        
    }
    
    private func AutoLayoutForAllViews() {
        
        courseImageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(self.view.snp.topMargin)
            make.height.equalTo(180)
        }
        
        lblTitleDescription.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(15)
            make.top.equalTo(courseImageView.snp.bottom).offset(10)
            make.height.equalTo(25)
        }
        
        lblDescription.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(15)
            make.top.equalTo(lblTitleDescription.snp.bottom).offset(5)
            make.height.lessThanOrEqualTo(45)
        }
        
        if userIsEnrolled {
            lblTitleChapter.snp.makeConstraints { (make) in
                make.leading.trailing.equalTo(view).inset(20)
                make.top.equalTo(lblDescription.snp.bottom).offset(15)
                make.height.equalTo(25)
            }
        }else{
            btnEnrollNow.snp.makeConstraints { (make) in
                make.leading.trailing.equalTo(self.view).inset(20)
                make.top.equalTo(lblDescription.snp.bottom).offset(10)
                make.height.lessThanOrEqualTo(50)
            }
                
            lblTitleChapter.snp.makeConstraints { (make) in
                make.leading.trailing.equalTo(view).inset(20)
                make.top.equalTo(btnEnrollNow.snp.bottom).offset(15)
                make.height.equalTo(25)
            }
        }
        
        tblViewChapterDetials.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(view)
            make.top.equalTo(lblTitleChapter.snp.bottom).offset(15)
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(view.center)
            make.width.height.equalTo(80)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allChapterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterDetailsTableViewCell", for: indexPath) as! ChapterDetailsTableViewCell
        
        let (h,m) = secondsToHoursMinutesSeconds(milliSeconds: Int(allChapterData[indexPath.row].chapterDuration)!)
        
        cell.lblChapterName.text = allChapterData[indexPath.row].chapterName
        
        if h == 0 {
        cell.lblChapterDuration.text = "Duration: \(m)m"
        }else{
        cell.lblChapterDuration.text = "Duration: \(h)h \(m)m"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userIsEnrolled {
            showVideoPlayer(index: indexPath.row)
        }else{
            let alert = UIAlertController(title: "Enroll in to course", message: "Enroll now to watch videos!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
            alert.addAction(UIAlertAction(title: "Enroll Now", style: .default, handler: { (alertAction) in
                self.arrEnrolledUsers.append(self.userId!)
                let value = ["enrolledusers" : self.arrEnrolledUsers]
                let ref = globalConstants.firestoreAllCoursesRef.document(self.strDocumentKeyID)
                ref.setData(value, merge: true) { (err) in
                    let alert = UIAlertController(title: "Unknown error", message: "\(err.debugDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                self.userIsEnrolled = true
                
                let alert = UIAlertController(title: "", message: "Successfully Enrolled in Course", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                    UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                        self.btnEnrollNow.snp.updateConstraints { (make) in
                            make.leading.trailing.equalTo(self.view).inset(20)
                            make.top.equalTo(self.lblDescription.snp.bottom)
                            make.height.lessThanOrEqualTo(0)
                        }
                        self.showVideoPlayer(index: indexPath.row)
                    })
                }))
                self.present(alert, animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showVideoPlayer(index: Int) {
        
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let chapterKeyId = allChapterData[index].documentKeyID
        print(chapterKeyId)
        
        var seekToSeconds = 0
        
        let ref = globalConstants.firestoreAllCoursesRef.document(strDocumentKeyID).collection("modules").document(chapterKeyId).collection("enrolledusers").document(userId!)
        
        ref.getDocument { (snap, err) in
            if err != nil {
                    let alert = UIAlertController(title: "", message: "\(err!.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    return
                }
            
            if snap!.exists {
                let data = snap!.data()!
                let indexData = data["index"] as! [String : Any]
                let miliseconds = indexData["seekto"]
                seekToSeconds = miliseconds as! Int
            }else{
                seekToSeconds = 0
            }
            
            let videoURL = URL(string: self.allChapterData[index].chapterVideoURL)
            let player = AVPlayer(url: videoURL!)
            self.playerViewController.player = player
            
            //let seekToSeconds = UserDefaults.standard.object(forKey: allChapterData[index].chapterName) as? Int
            
            if seekToSeconds != 0 {
                let value = Double(seekToSeconds)/60
                let seekTime = CMTime(seconds: value, preferredTimescale: 60000)
                self.playerViewController.player?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { (completed) in
                })
            }
            
            self.present(self.playerViewController, animated: true) {
                self.playerViewController.player!.play()
            }
            
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
        }
        
        playerViewController.onDismiss = { [weak self] in
            //print(self!.playerViewController.player?.currentItem?.duration as Any)
            
            let username = UserDefaults.standard.value(forKey: "userName")
            let userid = UserDefaults.standard.value(forKey: "mobileNumber")
            
            if let duration = self!.playerViewController.player?.currentTime() {
                let seconds = CMTimeGetSeconds(duration)
                let milliSeconds = Int(seconds * 60)
                UserDefaults.standard.set(Int(seconds), forKey: self!.allChapterData[index].chapterName)
                
                let index = ["i" : 1, "seekto" : milliSeconds] as [String : Any]
                
                let value = ["userid" : userid!, "username" : username!, "index" : index] as [String : Any]
                
                let ref = globalConstants.firestoreAllCoursesRef.document(self!.strDocumentKeyID).collection("modules").document(chapterKeyId).collection("enrolledusers").document((self?.userId!)!)
                ref.setData(value, merge: true)
            }
        }
    }
    
    @objc func playerDidFinishPlaying() {
        print(self.playerViewController.player?.currentTime() as Any)
    }
    
    @objc func btnEnrollNowPressed() {
        
        if userIsEnrolled {
            let alert = UIAlertController(title: "", message: "Already Enrolled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }else{
            arrEnrolledUsers.append(userId!)
            let value = ["enrolledusers" : arrEnrolledUsers]
            let ref = globalConstants.firestoreAllCoursesRef.document(strDocumentKeyID)
            ref.setData(value, merge: true) { (err) in
                let alert = UIAlertController(title: "Unknown error", message: "\(err.debugDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.userIsEnrolled = true
            
            let alert = UIAlertController(title: "", message: "Successfully Enrolled in Course", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.btnEnrollNow.snp.updateConstraints { (make) in
                        make.leading.trailing.equalTo(self.view).inset(20)
                        make.top.equalTo(self.lblDescription.snp.bottom)
                        make.height.lessThanOrEqualTo(0)
                    }
                })
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func fetchAllChapterDetails() {
        
        
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let ref = globalConstants.firestoreAllCoursesRef.document(strDocumentKeyID).collection("modules")
        ref.order(by: "order").getDocuments { (snap, err) in
            if err != nil {
                let alert = UIAlertController(title: "", message: "\(err!.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
                
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                return
            }
            
            for document in snap!.documents {
                let chapterData = document.data()
                
                let chapterName = chapterData["chapter"] as! String
                let chapterDuration = chapterData["duration"] as! String
                let chapterVideoURL = chapterData["videourl"] as! String
                let chapterDescription = chapterData["description"] as! String
                let documentKeyID = chapterData["documentKeyID"] as! String
                
                self.allChapterData.append(chapterDetails(chapterName: chapterName, chapterDescription: chapterDescription, chapterDuration: chapterDuration, chapterVideoURL: chapterVideoURL, documentKeyID: documentKeyID))
                
            }
            
            self.tblViewChapterDetials.reloadData()
            self.tblViewChapterDetials.isHidden = false
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
        
    }
}

struct chapterDetails: Codable {
    var chapterName : String
    var chapterDescription : String
    var chapterDuration : String
    var chapterVideoURL : String
    var documentKeyID : String
}

func secondsToHoursMinutesSeconds (milliSeconds : Int) -> (Int, Int) {
  return (milliSeconds / 3600, (milliSeconds % 3600) / 60)
}

class MYVideoController: AVPlayerViewController {

  typealias DissmissBlock = () -> Void
  var onDismiss: DissmissBlock?

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if isBeingDismissed {
      onDismiss?()
    }
  }
}
