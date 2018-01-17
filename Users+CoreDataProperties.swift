//
//  Users+CoreDataProperties.swift
//  FforN
//
//  Created by Dama Narendra on 12/4/16.
//  Copyright © 2016 Narendra Dama. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Users {

    @NSManaged var id_user: NSNumber?
    @NSManaged var first_name: String?
    @NSManaged var last_name: String?
    @NSManaged var user_name: String?

}
