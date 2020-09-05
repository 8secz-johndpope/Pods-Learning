//
//  globalConstants.swift
//  Sketch It
//
//  Created by kamlesh on 26/08/20.
//  Copyright © 2020 kamlesh. All rights reserved.
//

import Foundation
import Firebase

struct globalConstants {
    
    static var userId = Auth.auth().currentUser?.uid
    
    static var firestoreRef = Firestore.firestore().collection("Users").document(userId!)
    
    static var firestoreAllCoursesRef = Firestore.firestore().collection("courses")
    
}

struct Line {
    let strokeWidth: Float
    let color: UIColor
    var points: [CGPoint]
}
