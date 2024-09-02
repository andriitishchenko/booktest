//
//  BookItem+CoreDataClass.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-30.
//
//

import Foundation
import CoreData

@objc(BookItem)
public class BookItem: NSManagedObject {

}


extension BookItem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookItem> {
        return NSFetchRequest<BookItem>(entityName: "BookItem")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var coverImageURL: String?
    @NSManaged public var bookDescription: String?
    @NSManaged public var isFavorite: Bool
}

extension BookItem : Identifiable {

}
