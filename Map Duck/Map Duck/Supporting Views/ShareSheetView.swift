//
//  ShareSheetView.swift
//  Map Duck
//
//  Created by Idan Birman on 30/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//

import SwiftUI

class UIActivityViewControllerHost: UIViewController {
    var message = ""
    var completionWithItemsHandler: UIActivityViewController.CompletionWithItemsHandler? = nil
     
    override func viewDidAppear(_ animated: Bool) {
        share()
    }
     
    func share() {
        // set up activity view controller
        let textToShare = [ message ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
  
  
        activityViewController.completionWithItemsHandler = completionWithItemsHandler
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
  
  
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
  
  
struct ActivityViewController: UIViewControllerRepresentable {
    @Binding var text: String
    @Binding var showing: Bool
     
    func makeUIViewController(context: Context) -> UIActivityViewControllerHost {
        // Create the host and setup the conditions for destroying it
        let result = UIActivityViewControllerHost()
         
        result.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            // To indicate to the hosting view this should be "dismissed"
            self.showing = false
        }
         
        return result
    }
     
    func updateUIViewController(_ uiViewController: UIActivityViewControllerHost, context: Context) {
        // Update the text in the hosting controller
        uiViewController.message = text
    }
     
}
  
