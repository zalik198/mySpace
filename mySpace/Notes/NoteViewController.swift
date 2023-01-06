//
//  NoteViewController.swift
//  mySpace
//
//  Created by Shom on 23.12.2022.
//


import UIKit
import SnapKit

class NoteViewController: UIViewController, UITextFieldDelegate {
    
    var note: Note?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = true
        scrollView.indicatorStyle = .black
        return scrollView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        nameLabel.text = "НАЗВАНИЕ"
        nameLabel.textColor = .systemGray
        return nameLabel
    }()
    
    let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.font = .systemFont(ofSize: 17, weight: .regular)
        nameTextField.textAlignment = .left
        nameTextField.placeholder = "Сходить в магазин, написать 100 строчек кода и т.п."
        return nameTextField
    }()
    
    let notesTextField: UITextView = {
        let notesTextField = UITextView()
        notesTextField.font = .systemFont(ofSize: 17, weight: .regular)
        notesTextField.textAlignment = .left
        notesTextField.layer.borderWidth = 0.3
        notesTextField.layer.borderColor = UIColor.black.cgColor
        notesTextField.layer.cornerRadius = 10
        return notesTextField
    }()
    
    lazy var colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        colorLabel.text = "ЦВЕТ"
        colorLabel.textColor = .systemGray
        return colorLabel
    }()
    
    lazy var pickerButton: UIButton = {
        let pickerButton = UIButton()
        pickerButton.layer.cornerRadius = 15
        pickerButton.backgroundColor = UIColor(red: 1.00, green: 0.62, blue: 0.31, alpha: 1.00)
        pickerButton.clipsToBounds = true
        pickerButton.addTarget(self, action: #selector(pickerTap), for: .touchUpInside)
        return pickerButton
    }()
    
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        dateLabel.text = "Дата создания"
        dateLabel.textColor = .systemGray
        return dateLabel
    }()
    
    let selectDate: UILabel = {
        let selectDate = UILabel()
        selectDate.font = .systemFont(ofSize: 17)
        return selectDate
    }()
    
    var date: Date = Date() {
        didSet {
            let dateformat = DateFormatter()
            dateformat.dateFormat = "MM-dd-yyyy HH:mm"
            dateValueLabel.text = dateformat.string(from: date)
        }
    }
    
    lazy var dateValueLabel: UILabel = {
        let dateValueLabel = UILabel()
        dateValueLabel.font = .systemFont(ofSize: 17, weight: .regular)
        dateValueLabel.numberOfLines = 1
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy HH:mm"
        dateValueLabel.textColor = constPurpleColor
        dateValueLabel.text = dateFormat.string(from: date)
        return dateValueLabel
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = date
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.addTarget(self, action: #selector(datePickerTap), for: .valueChanged)
        return datePicker
    }()
    
    lazy var deleteNoteButton: UIButton = {
        let deleteNoteButton = UIButton()
        deleteNoteButton.setTitle("Удалить заметку", for: .normal)
        deleteNoteButton.titleLabel?.font = .systemFont(ofSize: 17)
        deleteNoteButton.setTitleColor(UIColor(red: 1.00, green: 0.23, blue: 0.19, alpha: 1.00), for: .normal)
        deleteNoteButton.addTarget(self, action: #selector(deleteTap), for: .touchUpInside)
        return deleteNoteButton
    }()
    
    init(_ editNote: Note?) {
        
        super.init(nibName: nil, bundle: nil)
        
        note = editNote
        if let noteSource = note {
            date = noteSource.date
            pickerButton.backgroundColor = noteSource.color
            nameTextField.text = noteSource.name
            notesTextField.text = noteSource.text
            deleteNoteButton.isHidden = false
            datePicker.isHidden = true
            title = "Править"
        } else {
            deleteNoteButton.isHidden = true
            datePicker.isHidden = false
            title = "Создать"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveNote))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelNote))
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.addSubviews(nameLabel, nameTextField, notesTextField, colorLabel, pickerButton, dateLabel, dateValueLabel, datePicker, deleteNoteButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        view.addGestureRecognizer(tapGesture)
        self.nameTextField.delegate = self
        initialLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: Initial Layout SnapKit
    func initialLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.width.trailing.leading.equalTo(view.safeAreaLayoutGuide)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(scrollView).offset(16)
            make.width.equalTo(125)
            make.height.height.equalTo(20)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(scrollView).offset(16)
            make.height.equalTo(30)
            make.width.equalTo(250)
        }
        notesTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
            make.leading.equalTo(scrollView).offset(16)
            make.trailing.equalTo(scrollView).inset(16)
            make.height.equalTo(150)
        }
        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(notesTextField.snp.bottom).offset(36)
            make.leading.equalTo(scrollView).offset(16)
            make.height.equalTo(18)
            make.width.equalTo(36)
        }
        pickerButton.snp.makeConstraints { make in
            make.top.equalTo(colorLabel.snp.bottom).offset(8)
            make.leading.equalTo(scrollView).offset(16)
            make.height.width.equalTo(30)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(pickerButton.snp.bottom).offset(24)
            make.leading.equalTo(scrollView).offset(16)
            make.height.equalTo(16)
            make.width.equalTo(125)
        }
        dateValueLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.equalTo(scrollView).offset(16)
            make.height.equalTo(24)
        }
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(dateValueLabel).offset(16)
            make.leading.trailing.equalTo(scrollView)
            make.height.equalTo(216)
            make.width.equalTo(scrollView.contentSize.width)
        }
        deleteNoteButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(18)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: target image button
    @objc func pickerTap() {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.selectedColor = pickerButton.backgroundColor!
        present(colorPickerVC, animated: true)
    }
    
    //MARK: target tap datePicker
    @objc func datePickerTap( _ sender: UIDatePicker) {
        date = sender.date
    }
    
    //MARK: tap on view keyboard closed
    @objc func tapOnView() {
        nameTextField.resignFirstResponder()
        notesTextField.resignFirstResponder()
    }
    
    //MARK: tap keyboard button "done" close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: target save button
    @objc func saveNote() {
        if let myNote = note {
            myNote.name = nameTextField.text!
            myNote.date = date
            myNote.color = pickerButton.backgroundColor!
            myNote.text = notesTextField.text!
            NotesStore.shared.save()
            NotesViewController.collectionView.reloadData()
            
            let viewControllers = self.navigationController!.viewControllers
            let lastTwoVC = viewControllers[viewControllers.count - 2]
            self.navigationController?.popToViewController(lastTwoVC, animated: true)
            
        } else {
            let newNote = Note(name: nameTextField.text!, text: notesTextField.text!, date: date, color: pickerButton.backgroundColor!)
            let store = NotesStore.shared
            if !store.notes.contains(newNote) {
                store.notes.append(newNote)
                NotesViewController.collectionView.reloadData()
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: target cancel button
    @objc func cancelNote() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: delete note in tap UIAlecrController
    @objc func deleteTap() {
        let alertController = UIAlertController(title: "Удалить заметку", message: "Вы хотите удалить заметку \"\(nameTextField.text ?? "Без имени")\"?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { (action) -> Void in
            if let selfNote = self.note {
                NotesStore.shared.notes.removeAll(where: {$0 == selfNote})
                NotesViewController.collectionView.reloadData()
            }
            
            let viewControllers = self.navigationController!.viewControllers
            let lastTwoVC = viewControllers[viewControllers.count - 2]
            self.navigationController?.popToViewController(lastTwoVC,animated:false)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: Extension NoteViewController
extension NoteViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        pickerButton.backgroundColor = color
    }
}

