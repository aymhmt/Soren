import UIKit
import FirebaseAuth

class loginViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Soren"
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 24)
        title.textAlignment = .center
        return title
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Şifremi Unuttum", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return button
    }()
    
    private let registerLabel: UILabel = {
        let label = UILabel()
        let text = "Hesabın yok mu? Kayıt Ol"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: (text as NSString).range(of: "Kayıt Ol"))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .bold), range: (text as NSString).range(of: "Kayıt Ol"))
        
        label.attributedText = attributedString
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(registerLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(registerLabelTapped))
        registerLabel.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.frame = CGRect(x: 20, y: 200, width: view.frame.size.width - 40, height: 50)
        emailTextField.frame = CGRect(x: 20, y: 280, width: view.frame.size.width - 40, height: 50)
        passwordTextField.frame = CGRect(x: 20, y: emailTextField.frame.maxY + 20, width: view.frame.size.width - 40, height: 50)
        loginButton.frame = CGRect(x: 20, y: passwordTextField.frame.maxY + 20, width: view.frame.size.width - 40, height: 50)
        forgotPasswordButton.frame = CGRect(x: view.frame.size.width - 120, y: loginButton.frame.maxY + 10, width: 100, height: 30)
        registerLabel.frame = CGRect(x: 20, y: view.frame.size.height - 100, width: view.frame.size.width - 40, height: 30)
    }
    
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Lütfen tüm alanları doldurun")
            return
        }
 
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Giriş başarısız: \(error.localizedDescription)")
                return
            }
            
            print("Giriş başarılı: \(authResult?.user.email ?? "")")
            
            let homeVC = ViewController()
            homeVC.modalPresentationStyle = .fullScreen
            self?.present(homeVC, animated: true, completion: nil)
        }
    }
    
    @objc private func forgotPasswordTapped() {
        let forgotPasswordVC = ForgotPasswordViewController()
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    @objc private func registerLabelTapped() {
        let signVC = SignViewController()
        self.navigationController?.pushViewController(signVC, animated: true)
    }
}
