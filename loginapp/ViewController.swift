import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    private let exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(exitButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Exit butonunun çerçevesini ayarla
        exitButton.frame = CGRect(x: 20, y: 380, width: view.frame.size.width - 40, height: 50)
    }
    
    @objc private func exitButtonTapped() {
        do {
            // Firebase oturumu kapatma işlemi
            try Auth.auth().signOut()
            print("Başarıyla çıkış yapıldı!")
            
            // Kullanıcıyı giriş ekranına yönlendir
            let loginVC = loginViewController() // Giriş ekranı sınıfını kullanın
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Çıkış yapılırken hata oluştu: \(signOutError.localizedDescription)")
        }
    }
}
