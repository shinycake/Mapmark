//
//  TagsList.swift
//  Map Duck
//
//  Created by Idan Birman on 27/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//

import SwiftUI
import CoreData

struct TagsList: View {
    @ObservedObject var location : SavedLocation
    @State var editingEnabled = false
    
    @State private var isAddingTag = false
    @State private var newTagInput : String = ""
    @State var tagsFont : Font = .headline
    
    enum TagAdditonState : String{
        case notAdding
        case addingEmpty
        case addingContent
    }
    
    var tagAdditionState : TagAdditonState {
        if !isAddingTag {
            return .notAdding
        } else {
            if newTagInput.count > 0 {
                return .addingContent
            } else {
                return .addingEmpty
            }
        }
    }
    
    var addButtonImageName : String {
        switch tagAdditionState {
        case .notAdding:
            return "plus.circle"
        case .addingEmpty:
            return "xmark.circle"
        case .addingContent:
            return "plus.circle.fill"
        }
    }
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                ForEach(location.tagsArray ?? [Tag](), id: \.self) { tag in
                    HStack {
                        if self.editingEnabled {
                            Button(action: {
                                // do the thing
                                UIApplication.shared.endEditing()
                                self.location.removeFromTags(tag)
                                self.location.objectWillChange.send()
                            }) {
                                Image(systemName: "minus.circle")
                                    .padding(.vertical)
                                    .font(.system(size: 22))
                                    .foregroundColor(.red)
                            }
                        }
                        TagView(name: tag.name!, font: self.tagsFont)
                        if self.editingEnabled {
                            Text("|")
                        }
                    }
                }
                if editingEnabled {
                    Button(action: {
                        UIApplication.shared.endEditing()
                        // do the thing
                        switch self.tagAdditionState {
                            case .addingContent:
                                self.location.addToTags(Tag.named(self.newTagInput))
                                self.isAddingTag.toggle()
                            default:
                                self.isAddingTag.toggle()
                        }
                    }) {
                        Image(systemName: addButtonImageName)
                            .padding([.vertical,.trailing])
                            .font(.system(size: 22))
                    }
                    if isAddingTag {
                        HStack(spacing: 0) {
                            Text("#")
                            TextField("tag", text: $newTagInput)
                                .onDisappear {
                                    self.newTagInput = ""
                            }
                        }.animation(.easeInOut)
                    }
                }
            }
        }
    }
}

struct TagsList_Previews: PreviewProvider {
    static var previews: some View {
        TagsList(location: SavedLocation.dummy())
    }
}
