import UIKit
import FirebaseAuth

class SignViewController: UIViewController {

    // UI Elemanları
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Adınız"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-posta"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Şifre"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kayıt Ol", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)

        nameTextField.frame = CGRect(x: 20, y: 200, width: view.frame.size.width - 40, height: 50)
        emailTextField.frame = CGRect(x: 20, y: nameTextField.frame.maxY + 20, width: view.frame.size.width - 40, height: 50)
        passwordTextField.frame = CGRect(x: 20, y: emailTextField.frame.maxY + 20, width: view.frame.size.width - 40, height: 50)
        signUpButton.frame = CGRect(x: 20, y: passwordTextField.frame.maxY + 20, width: view.frame.size.width - 40, height: 50)
    }

    @objc private func signUpButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Lütfen tüm alanları doldurun.")
            return
        }
        
        signUpUser(name: name, email: email, password: password)
    }

    private func signUpUser(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Kayıt sırasında hata oluştu: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else { return }
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Kullanıcı adı güncellenirken hata oluştu: \(error.localizedDescription)")
                } else {
                    print("Kullanıcı kaydı başarılı ve adı güncellendi.")
                }
            }

            self.navigateToLogin()
        }
    }

    private func navigateToLogin() {
        let loginVC = loginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}
