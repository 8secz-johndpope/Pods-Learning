//
//  ChapterDetailsTableViewCell.swift
//  Pods Learning
//
//  Created by kamlesh on 03/09/20.
//  Copyright © 2020 kamlesh. All rights reserved.
//

import UIKit

class ChapterDetailsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        AutoLayoutForAllViews()
    }
    
     lazy var lblChapterName : UILabel = {
        let name = UILabel()
        name.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        name.textColor = .black
        return name
     }()
    
    lazy var lblChapterDuration : UILabel = {
       let name = UILabel()
       name.font = UIFont(name: "HelveticaNeue", size: 12)
       name.textColor = .black
       return name
     }()
    
    
    private func AutoLayoutForAllViews() {
        
        self.contentView.addSubview(lblChapterName)
        self.contentView.addSubview(lblChapterDuration)
        self.contentView.backgroundColor = .white
        
        
        lblChapterName.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self.contentView).inset(15)
            make.height.equalTo(25)
        }
        
        lblChapterDuration.snp.makeConstraints { (make) in
            make.top.equalTo(lblChapterName.snp.bottom).offset(5)
            make.centerX.equalTo(self.contentView)
            make.leading.trailing.bottom.equalTo(self.contentView).inset(15)
        }
    }
}
