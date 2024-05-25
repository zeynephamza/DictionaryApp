import Foundation
import UIKit
import DictionaryAPI
import AVFoundation

protocol DetailViewControllerProtocol: AnyObject {
    func displayWordDetails(_ wordElement: WordElement)
    func displayError(_ error: String)
    func showWordDetail(word: String)
}

class DetailViewController: UIViewController {
    var presenter: DetailPresenterProtocol?
    private var selectedPartsOfSpeech = Set<String>()
    private var wordDetails: WordElement?
    private var selectedButtons = [UIButton]()

    private let wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let phoneticLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        return label
    }()
    
    private let partOfSpeechScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let partOfSpeechStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    private let synonymOuterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10 
        return stackView
    }()
    private let synonymScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = true
        return scrollView
    }()
    
    private let synonymStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let synonymTitleLabel: UILabel = {
       let label = UILabel()
       label.font = UIFont.boldSystemFont(ofSize: 18)
       label.text = "Synonym"
       return label
   }()
    
    
    private let meaningsTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        return textView
    }()
    
    private let audioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.wave.2"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        presenter?.viewDidLoad()
        
        print("wordLabel görünürlüğü: \(wordLabel.isHidden)")
            print("audioButton görünürlüğü: \(audioButton.isHidden)")
            print("wordLabel frame: \(wordLabel.frame)")
            print("audioButton frame: \(audioButton.frame)")
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if presentingViewController != nil {
            let backButton = UIButton(type: .custom)
            backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
            backButton.addTarget(self, action: #selector(dismissDetail), for: .touchUpInside)
            backButton.frame = CGRect(x: 0, y: 40, width: 60, height: 60)
            backButton.tintColor = .gray
            view.addSubview(backButton)
        }
    }
    
    @objc private func dismissDetail() {
        dismiss(animated: true, completion: nil)
        let homeVC = HomeRouter.createModule()
        homeVC.modalPresentationStyle = .fullScreen
        if let viewController = view as? UIViewController {
            viewController.present(homeVC, animated: true, completion: nil)
        }
    }
    private func setupUI() {
        view.addSubview(wordLabel)
        view.addSubview(phoneticLabel)
        view.addSubview(partOfSpeechScrollView)
        partOfSpeechScrollView.addSubview(partOfSpeechStackView)
        view.addSubview(meaningsTextView)
        view.addSubview(audioButton)
        view.addSubview(synonymOuterStackView)

        synonymOuterStackView.addArrangedSubview(synonymTitleLabel)
        synonymOuterStackView.addArrangedSubview(synonymScrollView)
        synonymScrollView.addSubview(synonymStackView)

        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneticLabel.translatesAutoresizingMaskIntoConstraints = false
        partOfSpeechScrollView.translatesAutoresizingMaskIntoConstraints = false
        partOfSpeechStackView.translatesAutoresizingMaskIntoConstraints = false
        meaningsTextView.translatesAutoresizingMaskIntoConstraints = false
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        synonymOuterStackView.translatesAutoresizingMaskIntoConstraints = false
        synonymScrollView.translatesAutoresizingMaskIntoConstraints = false
        synonymStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            wordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            audioButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            audioButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            audioButton.widthAnchor.constraint(equalToConstant: 40),
            audioButton.heightAnchor.constraint(equalToConstant: 40),

            phoneticLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 8),
            phoneticLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            phoneticLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            partOfSpeechScrollView.topAnchor.constraint(equalTo: phoneticLabel.bottomAnchor, constant: 16),
            partOfSpeechScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            partOfSpeechScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            partOfSpeechScrollView.heightAnchor.constraint(equalToConstant: 50),

            partOfSpeechStackView.topAnchor.constraint(equalTo: partOfSpeechScrollView.topAnchor),
            partOfSpeechStackView.leadingAnchor.constraint(equalTo: partOfSpeechScrollView.leadingAnchor),
            partOfSpeechStackView.trailingAnchor.constraint(equalTo: partOfSpeechScrollView.trailingAnchor),
            partOfSpeechStackView.bottomAnchor.constraint(equalTo: partOfSpeechScrollView.bottomAnchor),
            partOfSpeechStackView.heightAnchor.constraint(equalTo: partOfSpeechScrollView.heightAnchor),

            meaningsTextView.topAnchor.constraint(equalTo: partOfSpeechScrollView.bottomAnchor, constant: 16),
            meaningsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            meaningsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            meaningsTextView.bottomAnchor.constraint(equalTo: synonymOuterStackView.topAnchor, constant: -16),

            synonymOuterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            synonymOuterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            synonymOuterStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            synonymScrollView.leadingAnchor.constraint(equalTo: synonymOuterStackView.leadingAnchor),
            synonymScrollView.trailingAnchor.constraint(equalTo: synonymOuterStackView.trailingAnchor),
            synonymScrollView.heightAnchor.constraint(equalToConstant: 50),
            
            synonymStackView.topAnchor.constraint(equalTo: synonymScrollView.topAnchor),
            synonymStackView.leadingAnchor.constraint(equalTo: synonymScrollView.leadingAnchor),
            synonymStackView.trailingAnchor.constraint(equalTo: synonymScrollView.trailingAnchor),
            synonymStackView.bottomAnchor.constraint(equalTo: synonymScrollView.bottomAnchor),
            synonymStackView.heightAnchor.constraint(equalTo: synonymScrollView.heightAnchor)
        ])
    }
    var player: AVPlayer?
    
    @objc func audioButtonTapped() {
        guard let audioURLString = wordDetails?.phonetics?[0].audio,
              let audioURL = URL(string: audioURLString) else {
            print("Audio URL not found!")
            return
        }
        
        guard let playerItem = try? AVPlayerItem(url: audioURL) else {
            print("Error creating player item")
            return
        }
        
        player = AVPlayer(playerItem: playerItem)
        
        player?.volume = 1.0 // Max sound level
        player?.play()
        
    }
       
    private func createPartOfSpeechButtons(for partsOfSpeech: [String]) {
        partOfSpeechStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("✕", for: .normal)
        clearButton.backgroundColor = .systemGray5
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        clearButton.layer.cornerRadius = 15
        clearButton.layer.masksToBounds = true
        clearButton.addTarget(self, action: #selector(clearFilterButtonTapped), for: .touchUpInside)
        partOfSpeechStackView.addArrangedSubview(clearButton)
        
        for part in partsOfSpeech {
            let button = UIButton(type: .system)
            button.setTitle(part.capitalized, for: .normal)
            button.backgroundColor = .systemGray5
            button.layer.cornerRadius = 15
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            button.addTarget(self, action: #selector(partOfSpeechButtonTapped(_:)), for: .touchUpInside)
            partOfSpeechStackView.addArrangedSubview(button)
        }
    }
    
    @objc private func clearFilterButtonTapped() {
        selectedPartsOfSpeech.removeAll()
        // Seçili butonların mavi çerçevesini kaldır
        selectedButtons.forEach { $0.layer.borderWidth = 0 }
        selectedButtons.removeAll()
        displayFullDefinitions()
    }

    private func displayFullDefinitions() {
        guard let word = wordDetails else { return }

        let attributedText = NSMutableAttributedString()

        word.meanings?.forEach { meaning in
            guard let partOfSpeech = meaning.partOfSpeech?.capitalized else { return }

            meaning.definitions?.enumerated().forEach { (index, definition) in
                let partOfSpeechText = NSAttributedString(string: "\(index + 1). \(partOfSpeech)\n", attributes: [
                    .font: UIFont.italicSystemFont(ofSize: 16),
                    .foregroundColor: UIColor.systemBlue
                ])

                let definitionText = NSAttributedString(string: "\(definition.definition ?? "")\n\n", attributes: [
                    .font: UIFont.systemFont(ofSize: 16),
                    .foregroundColor: UIColor.darkGray
                ])

                attributedText.append(partOfSpeechText)
                attributedText.append(definitionText)
            }
        }

        meaningsTextView.attributedText = attributedText

        if let synonyms = word.synonyms_api, !synonyms.isEmpty {
            synonymTitleLabel.isHidden = false
            synonymScrollView.isHidden = false

            synonymStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

            for synonym in synonyms.prefix(5) {
                let button = UIButton(type: .system)
                button.setTitle(synonym, for: .normal)
                button.backgroundColor = .systemGray5
                button.layer.cornerRadius = 15
                button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
                button.addTarget(self, action: #selector(synonymButtonTapped(_:)), for: .touchUpInside)
                synonymStackView.addArrangedSubview(button)
            }
        } else {
            synonymTitleLabel.isHidden = true
            synonymScrollView.isHidden = true
        }
    }


    @objc private func synonymButtonTapped(_ sender: UIButton) {
        presenter?.didTapOnSynonym(sender.currentTitle ?? "")
        //dismiss(animated: true, completion: nil)
    }
    @objc private func partOfSpeechButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        
        if selectedPartsOfSpeech.contains(title) {
            selectedPartsOfSpeech.remove(title)
            sender.layer.borderWidth = 0
            if let index = selectedButtons.firstIndex(of: sender) {
                selectedButtons.remove(at: index)
            }
        } else {
            selectedPartsOfSpeech.insert(title)
            sender.layer.borderWidth = 2
            sender.layer.borderColor = UIColor.systemBlue.cgColor
            selectedButtons.append(sender)
        }
        
        filterDefinitionsByPartOfSpeech()
    }
    
    private func filterDefinitionsByPartOfSpeech() {
        guard let word = wordDetails else { return }
        
        if selectedPartsOfSpeech.isEmpty {
            displayFullDefinitions()
            return
        }
        
        let attributedText = NSMutableAttributedString()

        word.meanings?.forEach { meaning in
            guard let partOfSpeech = meaning.partOfSpeech?.capitalized, selectedPartsOfSpeech.contains(partOfSpeech) else { return }
            
            meaning.definitions?.enumerated().forEach { (index, definition) in
                let partOfSpeechText = NSAttributedString(string: "\(index + 1). \(partOfSpeech)\n", attributes: [
                    .font: UIFont.italicSystemFont(ofSize: 16),
                    .foregroundColor: UIColor.systemBlue
                ])
                
                let definitionText = NSAttributedString(string: "\(definition.definition ?? "")\n\n", attributes: [
                    .font: UIFont.systemFont(ofSize: 16),
                    .foregroundColor: UIColor.darkGray
                ])
                
                attributedText.append(partOfSpeechText)
                attributedText.append(definitionText)
            }
        }

        meaningsTextView.attributedText = attributedText
    }

    func showError(_ error: String) {
        wordLabel.text = "Error: \(error)"
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    func displayError(_ error: String) {
        
        //Creates an alarm to show user
        let errorMessage = "Such a word may not exist or you can try again by checking your internet connection."
        let alertController = UIAlertController(title: "This word could not be fetched", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayWordDetails(_ word: WordElement) {
        print("DetailViewController: displayWordDetails")
        wordLabel.text = word.word?.capitalized
        phoneticLabel.text = word.phonetic
        
        // Clear existing partOfSpeech buttons
        partOfSpeechStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Store the word details for later use
        wordDetails = word

        // Create new partOfSpeech buttons
        if let meanings = word.meanings {
            let partsOfSpeech = meanings.compactMap { $0.partOfSpeech?.capitalized }
            createPartOfSpeechButtons(for: partsOfSpeech)
        }
        
        // Display all definitions initially
        displayFullDefinitions()
    }

    func showWordDetail(word: String) {
        wordLabel.text = word
    }
}
