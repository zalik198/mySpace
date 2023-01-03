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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = true
        scrollView.indicatorStyle = .black
        return scrollView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        nameLabel.text = "НАЗВАНИЕ"
        nameLabel.textColor = .systemGray
        return nameLabel
    }()
    
    let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.font = .systemFont(ofSize: 17, weight: .regular)
        nameTextField.textAlignment = .left
        nameTextField.placeholder = "Сходить в магазин, написать 100 строчек кода и т.п."
        return nameTextField
    }()
    
    let notesTextField: UITextView = {
        let notesTextField = UITextView()
        notesTextField.translatesAutoresizingMaskIntoConstraints = false
        notesTextField.font = .systemFont(ofSize: 17, weight: .regular)
        notesTextField.textAlignment = .left
        notesTextField.layer.borderWidth = 0.3
        notesTextField.layer.borderColor = UIColor.black.cgColor
        notesTextField.layer.cornerRadius = 10
        return notesTextField
    }()
    
    lazy var colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        colorLabel.text = "ЦВЕТ"
        colorLabel.textColor = .systemGray
        return colorLabel
    }()
    
    lazy var pickerButton: UIButton = {
        let pickerButton = UIButton()
        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        pickerButton.layer.cornerRadius = 15
        pickerButton.backgroundColor = UIColor(red: 1.00, green: 0.62, blue: 0.31, alpha: 1.00)
        pickerButton.clipsToBounds = true
        pickerButton.addTarget(self, action: #selector(pickerTap), for: .touchUpInside)
        return pickerButton
    }()
    
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        dateLabel.text = "Дата создания"
        dateLabel.textColor = .systemGray
        return dateLabel
    }()
    
    let selectDate: UILabel = {
        let selectDate = UILabel()
        selectDate.translatesAutoresizingMaskIntoConstraints = false
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
        dateValueLabel.translatesAutoresizingMaskIntoConstraints = false
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
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.date = date
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.addTarget(self, action: #selector(datePickerTap), for: .valueChanged)
        return datePicker
    }()
    
    lazy var deleteNoteButton: UIButton = {
        let deleteNoteButton = UIButton()
        deleteNoteButton.translatesAutoresizingMaskIntoConstraints = false
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
            title = "Править"
        } else {
            deleteNoteButton.isHidden = true
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
    
    //MARK: Initial Layout
    func initialLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.width.trailing.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(scrollView).offset(16)
            make.width.equalTo(125)
            make.height.height.equalTo(20)
        }
        
        
        NSLayoutConstraint.activate([
            //scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //                                     scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            //                                     scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            //                                     scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            //
            //                                     nameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            //                                     nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            //                                     nameLabel.heightAnchor.constraint(equalToConstant: 20),
            //                                     nameLabel.widthAnchor.constraint(equalToConstant: 125),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            nameTextField.heightAnchor.constraint(equalToConstant: 30),
            nameTextField.widthAnchor.constraint(equalToConstant: 176),
            
            notesTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            notesTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            notesTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            notesTextField.heightAnchor.constraint(equalToConstant: 150),
            
            
            colorLabel.topAnchor.constraint(equalTo: notesTextField.bottomAnchor, constant: 48),
            colorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            colorLabel.heightAnchor.constraint(equalToConstant: 18),
            colorLabel.widthAnchor.constraint(equalToConstant: 36),
            
            pickerButton.topAnchor.constraint(equalTo: colorLabel.topAnchor, constant: 25),
            pickerButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            pickerButton.heightAnchor.constraint(equalToConstant: 30),
            pickerButton.widthAnchor.constraint(equalToConstant: 30),
            
            dateLabel.topAnchor.constraint(equalTo: pickerButton.topAnchor, constant: 50),
            dateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 16),
            dateLabel.widthAnchor.constraint(equalToConstant: 125),
            
            dateValueLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 25),
            dateValueLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            dateValueLabel.heightAnchor.constraint(equalToConstant: 22),
            
            datePicker.topAnchor.constraint(equalTo: dateValueLabel.bottomAnchor, constant: 24),
            datePicker.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 216),
            datePicker.widthAnchor.constraint(equalToConstant: scrollView.contentSize.width),
            
            deleteNoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
            deleteNoteButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
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

