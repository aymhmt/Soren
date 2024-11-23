import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    var email: String?
    var resetCode: String?  

    private let newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Yeni şifrenizi girin"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Şifrenizi onaylayın"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.setTitle("Şifreyi Sıfırla", for: .normal)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("E-posta: \(email ?? "Bilgi yok")")
        print("Doğrulama Kodu: \(resetCode ?? "Kodu alınamadı")")
    }

    private func setupUI() {
        view.addSubview(newPasswordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(resetButton)
        view.backgroundColor = .systemBackground
        
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newPasswordTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            newPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            resetButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 20),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func resetButtonTapped() {
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            print("Şifreler gerekli!")
            showError(message: "Lütfen tüm alanları doldurun.")
            return
        }

        if newPassword != confirmPassword {
            print("Şifreler eşleşmiyor!")
            showError(message: "Şifreler eşleşmiyor!")
            return
        }

        guard let resetCode = resetCode else {
            print("Doğrulama kodu eksik!")
            showError(message: "Doğrulama kodu eksik!")
            return
        }

        // Şifreyi sıfırla
        resetPassword(resetCode: resetCode, newPassword: newPassword)
    }

    private func resetPassword(resetCode: String, newPassword: String) {
        Auth.auth().confirmPasswordReset(withCode: resetCode, newPassword: newPassword) { error in
            if let error = error {
                print("Şifre sıfırlanamadı: \(error.localizedDescription)")
                self.showError(message: "Şifre sıfırlanamadı: \(error.localizedDescription)")
                return
            }

            print("Şifre başarıyla sıfırlandı!")
            self.showSuccessAlert()
        }
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Başarılı", message: "Şifreniz başarıyla sıfırlandı.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true, completion: nil)
    }
}
