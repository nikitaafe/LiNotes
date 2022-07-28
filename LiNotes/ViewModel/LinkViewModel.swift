//
//  LinkViewModel.swift
//  LiNotes
//
//  Created by Nikita Felicia on 21/07/22.
//

import SwiftUI
import CoreData

class LinkViewModel: ObservableObject {
    @Published var currentTab: String = "Today"
  
    @Published var openEditLink: Bool = false
    @Published var linkTitle: String = ""
    @Published var linkDetail: String = ""
    @Published var linkColor: String = "Yellow"
    @Published var linkDeadline: Date = Date()
    @Published var linkType: String = "Basic"
    @Published var showDatePicker: Bool = false
    
    @Published var editLink: Link?
    
    //buat add link (coredata)
    func addLink(context: NSManagedObjectContext)->Bool{
        // MARK: Updating Existing Data in Core Data
        var link: Link!
        if let editLink = editLink {
            link = editLink
        }else{
            link = Link(context: context)
        }
        link.title = linkTitle
        link.detail = linkDetail
        link.color = linkColor
        link.deadline = linkDeadline
        link.type = linkType
        link.isCompleted = false
        
        if let _ = try? context.save(){
            return true
        }
        return false
    }
    
    //reset data
    func resetLinkData(){
        linkType = "Basic"
        linkColor = "Yellow"
        linkTitle = ""
        linkDetail = ""
        linkDeadline = Date()
        editLink = nil
    }
    
    //setup link klo misal ada data
    func setupLink(){
        if let editLink = editLink {
            linkType = editLink.type ?? "Basic"
            linkColor = editLink.color ?? "Yellow"
            linkTitle = editLink.title ?? ""
            linkDetail = editLink.detail ?? ""
            linkDeadline = editLink.deadline ?? Date()
        }
    }
}
