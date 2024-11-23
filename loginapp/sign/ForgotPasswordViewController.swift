import UIKit

class ForgotPasswordViewController: UIViewController {

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-posta adresinizi girin"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let sendCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kod Gönder", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(sendCodeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var verificationCodes: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(emailTextField)
        view.addSubview(sendCodeButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emailTextField.frame = CGRect(x: 20, y: 200, width: view.frame.size.width - 40, height: 50)
        sendCodeButton.frame = CGRect(x: 20, y: emailTextField.frame.maxY + 20, width: view.frame.size.width - 40, height: 50)
    }
    
    @objc private func sendCodeButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            print("E-posta adresi gerekli!")
            return
        }
        
        let code = String(format: "%06d", arc4random_uniform(1000000))
        verificationCodes[email] = code
        

        print("E-posta: \(email) için doğrulama kodu: \(code)")
        
        // VerifyCodeViewController'a yönlendir
        let verifyVC = VerifyCodeViewController()
        verifyVC.email = email
        verifyVC.verificationCodes = verificationCodes // Kodları aktar
        self.navigationController?.pushViewController(verifyVC, animated: true)
    }
}
