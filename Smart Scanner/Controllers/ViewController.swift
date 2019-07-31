import UIKit
import TesseractOCR
import WeScan
import SVProgressHUD

class ViewController: UIViewController, G8TesseractDelegate {
    
    // MARK: - Properties
    
    let operationQueue = OperationQueue()
    
    lazy var scannedImage: UIImageView = {
        let scannedImage = UIImageView()
        scannedImage.image = #imageLiteral(resourceName: "camera1")
        scannedImage.contentMode = UIView.ContentMode.scaleAspectFill
        scannedImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scannedImage)
        return scannedImage
        
    }()
    
    lazy var ocrText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }()
    
    lazy var takePhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Scan Image", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(openCamera(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }()
    
    lazy var createContactButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Contact", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(createContact), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }()
    
    var newContact: Contact?
    
    lazy internal var tesseract: G8Tesseract = {
        let _tesseract = G8Tesseract(language: "eng")
        _tesseract?.delegate = self
        //_tesseract?.charWhitelist
        //_tesseract?.charBlacklist
        return _tesseract!
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Home"
        setupViews()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViews() {
        let guide = view.safeAreaLayoutGuide
        // scanned image
        scannedImage.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8).isActive = true
        scannedImage.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -8).isActive = true
        scannedImage.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16).isActive = true
        scannedImage.heightAnchor.constraint(equalToConstant: 200).isActive = true

        NSLayoutConstraint.activate([
            //ocr text
            ocrText.leadingAnchor.constraint(equalTo: scannedImage.leadingAnchor),
            ocrText.trailingAnchor.constraint(equalTo: scannedImage.trailingAnchor),
            ocrText.topAnchor.constraint(equalTo: scannedImage.bottomAnchor, constant: 8),
            ocrText.bottomAnchor.constraint(equalTo: takePhotoButton.topAnchor, constant: -8),
            
            //create contact button
            createContactButton.widthAnchor.constraint(equalToConstant: 200),
            createContactButton.heightAnchor.constraint(equalToConstant: 50),
            createContactButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -16),
            createContactButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            
            // take image button
            takePhotoButton.widthAnchor.constraint(equalToConstant: 200),
            takePhotoButton.bottomAnchor.constraint(equalTo: createContactButton.topAnchor, constant: -8),
            takePhotoButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            takePhotoButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    @objc func openCamera(sender: Any) {
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        present(scannerViewController, animated: true)
    }
    
    @objc func createContact() {
        let contactsVC = ContactsViewController()
        contactsVC.newContact = newContact
        self.navigationController?.pushViewController(contactsVC, animated: true)
//        self.present(contactsVC, animated: true, completion: nil)
        
    }
    
    func recognizeImageWithTesseract(image: UIImage) {
        SVProgressHUD.show(withStatus: "Recognizing text...")
        
        self.tesseract.image = image
        self.tesseract.recognize()
        var scanResults = [String]()
        
        if let s = self.tesseract.recognizedText {
            let detectorType: NSTextCheckingResult.CheckingType = [.address, .phoneNumber,
                                                                   .link, .date]
            newContact = Contact(firstName: "", lastName: "", company: "", address: "", phone: "", email: "", imageData: nil)
            do {
                let detector = try NSDataDetector(types: detectorType.rawValue)
                let results = detector.matches(in: s, options: [], range:
                    NSRange(location: 0, length: s.utf16.count))
                
                for result in results {
                    if let range = Range(result.range, in: s) {
                        let matchResult = s[range]
                        scanResults.append("\(matchResult)")
                        print("result: \(matchResult), range: \(result.range)")
                        if result.resultType == .phoneNumber {
                            newContact?.phone = "\(matchResult)"
                        }
                        if result.resultType == .address {
                            if matchResult.contains("@") {
                                newContact?.email = "\(matchResult)"
                            }
                            else {
                                newContact?.address = "\(matchResult)"
                            }
                        }
                    }
                }
                
                newContact?.email = getEmails(text: s).count > 0 ? getEmails(text: s)[0] : ""
                
                ocrText.text = "Useful info extracted: \n \(scanResults)"
                
            } catch {
                print("handle error")
            }
            SVProgressHUD.dismiss()
        }
        
    }
    
    func getEmails(text: String) -> [String] {
        if let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
        {
            let string = text as NSString
            
            return regex.matches(in: text, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "", with: "").lowercased()
            }
        }
        return []
    }
}

extension ViewController:  ImageScannerControllerDelegate {
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        // You are responsible for carefully handling the error
        print(error)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        // The user successfully scanned an image, which is available in the ImageScannerResults
        // You are responsible for dismissing the ImageScannerController
        
        scannedImage.image = results.scannedImage
        scanner.dismiss(animated: true)
        recognizeImageWithTesseract(image: results.scannedImage)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // The user tapped 'Cancel' on the scanner
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }
    
}
