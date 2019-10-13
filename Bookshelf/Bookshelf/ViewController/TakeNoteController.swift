//
//  TakeNoteController.swift
//  Bookshelf
//
//  Created by zijia on 10/12/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import UIKit

private let defaultText = "Take a note"

protocol takeNoteDelegate: class{
    func didSavedNote(note: String)
}

class TakeNoteController: UIViewController {
    
    var isbn13: String?
    var note: String?
    weak var delegate: takeNoteDelegate?
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = (note == nil) ? defaultText : note!
        textView.textColor = UIColor.lightGray
        textView.becomeFirstResponder()
        self.title = defaultText
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(sendButtonClicked))
    }

    @objc fileprivate func sendButtonClicked() {
        if let key = isbn13 {
            UserDefaults.standard.set(textView.text, forKey: key)
        }
        delegate?.didSavedNote(note: textView.text)
        self.navigationController?.popViewController(animated: true)
    }

}


extension TakeNoteController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == defaultText) {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = defaultText
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }
    
}
