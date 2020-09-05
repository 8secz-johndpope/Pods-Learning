//
//  CoursesCollectionViewCell.swift
//  Pods Learning
//
//  Created by kamlesh on 03/09/20.
//  Copyright © 2020 kamlesh. All rights reserved.
//

import UIKit

class CoursesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        AutoLayoutForAllViews()
    }
    
     lazy var imgViewCourse : UIImageView = {
        let image = UIImageView()
        return image
     }()
    
     lazy var lblCourseName : UILabel = {
        let name = UILabel()
        name.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        name.textColor = .black
        name.numberOfLines = 2
        name.textAlignment = .left
        return name
     }()
    
    lazy var lblTotalVideos : UILabel = {
       let name = UILabel()
       name.font = UIFont(name: "HelveticaNeue-Italic", size: 12)
       name.textColor = .black
       return name
     }()
    
    lazy var lblCourseDuration : UILabel = {
      let name = UILabel()
      name.font = UIFont(name: "HelveticaNeue-Italic", size: 12)
      name.textColor = .black
      return name
    }()
    
    lazy var lblCourseDescription : UILabel = {
      let name = UILabel()
      name.font = UIFont(name: "HelveticaNeue-Italic", size: 12)
      name.textColor = .black
      name.numberOfLines = 0
      name.textAlignment = .justified
      return name
    }()
    
    private func AutoLayoutForAllViews() {
        
        self.contentView.addSubview(imgViewCourse)
        self.contentView.addSubview(lblCourseName)
        self.contentView.addSubview(lblTotalVideos)
        self.contentView.addSubview(lblCourseDuration)
        self.contentView.addSubview(lblCourseDescription)
        self.contentView.backgroundColor = .white
        
        
        imgViewCourse.snp.makeConstraints { (make) in
            make.trailing.leading.top.equalTo(self.contentView)
            make.height.equalTo(self.contentView.frame.width - 30)
        }
        
        lblCourseName.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgViewCourse.snp.bottom).offset(10)
            make.leading.trailing.equalTo(self.imgViewCourse).inset(10)
            make.height.lessThanOrEqualTo(30)
        }
        
        lblCourseDuration.snp.makeConstraints { (make) in
            make.top.equalTo(lblCourseName.snp.bottom).offset(10)
            make.leading.equalTo(self.contentView).inset(10)
            make.height.equalTo(30)
        }
        
        lblTotalVideos.snp.makeConstraints { (make) in
            make.top.equalTo(lblCourseDuration)
            make.leading.equalTo(self.lblCourseDuration.snp.trailing).offset(10)
            make.height.equalTo(30)
        }
        
        lblCourseDescription.snp.makeConstraints { (make) in
            make.top.equalTo(lblTotalVideos.snp.bottom).offset(10)
            make.centerX.equalTo(self.contentView)
            make.leading.trailing.equalTo(self.contentView).inset(10)
        }
    }
}
