//
//  HomeViewController.swift
//  Pods Learning
//
//  Created by kamlesh on 03/09/20.
//  Copyright © 2020 kamlesh. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var allCoursesData : [AllCourses] = []
    
    private lazy var coursesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        return collectionView
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

        self.navigationItem.title = "Home"
        self.navigationItem.hidesBackButton = true
        
        // MARK: Logout Button
        let btnLogout = UIButton()
        btnLogout.setTitle("Logout", for: .normal)
        btnLogout.addTarget(self, action: #selector(btnLogoutTapped), for: .touchUpInside)
        btnLogout.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        btnLogout.setTitleColor(.black, for: .normal)
        let logoutItem = UIBarButtonItem(customView: btnLogout)
        self.navigationItem.setRightBarButton(logoutItem, animated: true)
        
        //MARK: Arranging Collection View Cell Item
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = self.view.frame.width - 40
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: width, height: self.view.frame.height - 90)
        
        coursesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        //MARK: Register custom collectionview cell to CollectionView
        coursesCollectionView.register(CoursesCollectionViewCell.self, forCellWithReuseIdentifier: "CoursesCollectionViewCell")
        
        coursesCollectionView.backgroundColor = .clear
        coursesCollectionView.isPagingEnabled = true
        coursesCollectionView.delegate = self
        coursesCollectionView.dataSource = self
        
        //MARK: Adding subviews to Superview
        view.addSubview(activityIndicator)
        view.addSubview(coursesCollectionView)
        
        coursesCollectionView.isHidden = true
        
        AutoLayoutForAllViews()
        
        view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        fetchAllCoursesDetails()
    }
    
    private func AutoLayoutForAllViews() {
        
        // For My Sketches Gallery
        coursesCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.topMargin.equalTo(view.snp.topMargin).inset(15)
            make.bottomMargin.equalTo(view.snp.bottomMargin).inset(15)
        }
        
        // For Loader
        activityIndicator.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.center.equalTo(view)
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(allCoursesData.count)
        return allCoursesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoursesCollectionViewCell", for: indexPath) as! CoursesCollectionViewCell
        
        let imageURL = URL(string: allCoursesData[indexPath.row].courseImage)
        
        let (h,m) = secondsToHoursMinutesSeconds(milliSeconds: Int(allCoursesData[indexPath.row].courseDuration))
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        
        cell.imgViewCourse.sd_setImage(with: imageURL)
        
        cell.lblTotalVideos.layer.cornerRadius = 8
        cell.lblTotalVideos.layer.borderColor = UIColor.black.cgColor
        cell.lblTotalVideos.layer.borderWidth = 0.5
        cell.lblTotalVideos.layer.masksToBounds = true
        cell.lblTotalVideos.text = "  \(allCoursesData[indexPath.row].totalVideos) Chapters  "
        
        cell.lblCourseName.text = allCoursesData[indexPath.row].courseName
        
        cell.lblCourseDuration.text = "  \(h)h \(m)m Course Duration  "
        cell.lblCourseDuration.layer.cornerRadius = 8
        cell.lblCourseDuration.layer.borderColor = UIColor.black.cgColor
        cell.lblCourseDuration.layer.borderWidth = 0.5
        cell.lblCourseDuration.layer.masksToBounds = true
        
        cell.lblCourseDescription.text = allCoursesData[indexPath.row].courseDescription
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextViewController = CourseDetailsViewController()
        nextViewController.strCourseName = allCoursesData[indexPath.row].courseName
        nextViewController.strCourseImage = allCoursesData[indexPath.row].courseImage
        nextViewController.strDescription = allCoursesData[indexPath.row].courseDescription
        nextViewController.strDocumentKeyID = allCoursesData[indexPath.row].documentKeyID
        nextViewController.arrEnrolledUsers = allCoursesData[indexPath.row].enrolledUsers
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func fetchAllCoursesDetails() {
        self.allCoursesData.removeAll()
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let ref = globalConstants.firestoreAllCoursesRef
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
                let courseData = document.data()
               
                let totalVideos = courseData["totalvideos"] as! Int
                let courseImage = courseData["courseimage"] as! String
                let courseName = courseData["coursename"] as! String
                let courseDescription = courseData["coursedescription"] as! String
                let documentKeyID = courseData["documentKeyID"] as! String
                let courseDuration = courseData["duration"] as! Int
                let enrolledUsers = courseData["enrolledusers"] as! [String]
                print(enrolledUsers)
                
                
                self.allCoursesData.append(AllCourses(courseName: courseName, courseImage: courseImage, courseDescription: courseDescription, documentKeyID: documentKeyID, courseDuration: courseDuration, totalVideos: totalVideos, enrolledUsers: enrolledUsers))
                
            }
            
            self.coursesCollectionView.reloadData()
            self.coursesCollectionView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    //MARK: Logout Button Action and Logout function
    @objc func btnLogoutTapped() {
        try! Auth.auth().signOut()
            
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.set("", forKey: "userName")
        UserDefaults.standard.set("", forKey: "mobileNumber")
        UserDefaults.standard.set("", forKey: "userId")
        
        let nextViewController = SignInViewController()
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
}

struct AllCourses: Codable {
    var courseName: String
    var courseImage: String
    var courseDescription: String
    var documentKeyID: String
    var courseDuration: Int
    var totalVideos: Int
    var enrolledUsers: [String]
}
