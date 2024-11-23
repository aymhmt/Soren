import UIKit
import FirebaseAuth

class VerifyCodeViewController: UIViewController {

    var email: String?
    var verificationCodes: [String: String] = [:]
    
    private var codeTextFields: [UITextField] = []
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Kodu almadınız mı?"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let resendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kodu tekrar gönder.", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let codeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kod Doğrula", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.addSubview(codeStackView)
        view.addSubview(label)
        view.addSubview(resendButton)
        view.addSubview(verifyButton)
        view.backgroundColor = .systemBackground

        for i in 0..<6 {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.textAlignment = .center
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry = false
            textField.delegate = self
            textField.tag = i
            codeStackView.addArrangedSubview(textField)
            codeTextFields.append(textField)
        }

        codeStackView.translatesAutoresizingMaskIntoConstraints = false
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        resendButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            codeStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            codeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            codeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            codeStackView.heightAnchor.constraint(equalToConstant: 70),
            
            label.topAnchor.constraint(equalTo: codeStackView.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            resendButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            resendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            verifyButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            verifyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            verifyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            verifyButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    @objc private func verifyButtonTapped() {
        let code = codeTextFields.map { $0.text ?? "" }.joined()
        guard code.count == 6 else {
            showError(message: "Kodun tamamını girin!")
            return
        }
        
        guard let email = email else {
            showError(message: "E-posta adresi bulunamadı.")
            return
        }

        if verificationCodes[email] == code {
            print("Kod doğrulandı! Şifre yenileme sayfasına yönlendiriliyor...")
                    
            let resetVC = ResetPasswordViewController()
            resetVC.email = email
            self.navigationController?.pushViewController(resetVC, animated: true)
        } else {
            showError(message: "Kod yanlış!")
        }
    }
    
    @objc private func updateButtonTapped() {
        guard let email = email else {
            showError(message: "E-posta adresi bulunamadı.")
            return
        }

        // Yeni kod oluştur
        let newCode = String(format: "%06d", arc4random_uniform(1000000))
        
        // Kodları güncelle
        verificationCodes[email] = newCode
        print("Yeni doğrulama kodu: \(newCode)")
        
        // Burada kodun kullanıcıya gönderilmesi işlemini ekleyebilirsiniz.
        // Örneğin, Firebase Cloud Functions ile e-posta gönderimi.
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension VerifyCodeViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count > 1 {
            return false
        }

        if let currentText = textField.text, currentText.count == 1, let nextTextField = codeTextFields.first(where: { $0.tag == textField.tag + 1 }) {
            nextTextField.becomeFirstResponder()
        }

        if string.isEmpty, let prevTextField = codeTextFields.first(where: { $0.tag == textField.tag - 1 }) {
            prevTextField.becomeFirstResponder()
        }

        return true
    }
}
