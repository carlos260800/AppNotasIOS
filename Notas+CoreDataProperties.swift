//
//  Notas+CoreDataProperties.swift
//  Notas
//
//  Created by Jose Carlos Corona Bautista on 03/03/23.
//
//

import Foundation
import CoreData


extension Notas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notas> {
        return NSFetchRequest<Notas>(entityName: "Notas")
    }

    @NSManaged public var titulo: String?
    @NSManaged public var info: String?

}

extension Notas : Identifiable {

}
