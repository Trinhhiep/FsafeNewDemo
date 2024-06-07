//
//  PopupHappyBirthDayWithGiftVC.swift
//  HiThemes_Example
//
//  Created by Trinh Quang Hiep on 06/02/2023.
//

import UIKit
import Lottie
import AVFAudio
class PopupHappyBirthDayWithGiftVC: BaseViewController {
    @IBOutlet weak var lblCustomerName: UILabel!
    
    @IBOutlet weak var btnGift: UIButton!
    
    @IBOutlet weak var imgHPBD: UIImageView!
    
    @IBOutlet weak var imgUserNameBG: UIImageView!
    
    @IBOutlet weak var imgBtnGift: UIImageView!
    
    @IBOutlet weak var gifView: UIView!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var centerView: UIView!
    
    @IBOutlet weak var imgLight: UIImageView!
    @IBOutlet weak var imgGifMascotGift: UIImageView!
    private var customerName: String = ""
    private var btnGifTitle: String = ""
    var callbackClose :(()->Void)?
    var callbackReceivingGifts :(()->Void)?
    let gifAnimationView = LottieAnimationView()
    var player: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        initGifView()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.playSound()
       
       
    }
    func playSound() {
            guard let path =  Bundle.resourceBundle(for: Self.self).path(forResource: "HappyBirthday", ofType:"mp3") else {
                return }
            let url = URL(fileURLWithPath: path)

            do {
                self.player = try AVAudioPlayer(contentsOf: url)
                self.player?.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    
    func setupUI(){
        imgHPBD.image = UIImage(named: "img_text_happy_birthday")
        imgUserNameBG.image = UIImage(named: "img_bg_of_text_layer_blue")
        imgBtnGift.image = UIImage(named: "img_button_orange")
        lblCustomerName.text = customerName
        btnGift.setTitle(btnGifTitle, for: .normal)
        btnClose.setImage(UIImage(named: "ic_close_fill"), for: .normal)
    }
    func inputData(customerName: String, btnGifTitle: String){
        self.customerName = customerName
        self.btnGifTitle = btnGifTitle
    }
    private func initGifView() -> Void {
        imgLight.image = UIImage(named: "light_HPBD")
        guard let imageBgHPBD = UIImage.gif(name: "mascot_gift",bundle: Bundle.resourceBundle(for: Self.self)) else
        {
            return
        }
        imgGifMascotGift.image = imageBgHPBD
        
        let bgHPBDConfetti = UIImageView()
        gifView.addSubview(bgHPBDConfetti)
        bgHPBDConfetti.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bgHPBDConfetti.leadingAnchor.constraint(equalTo: gifView.leadingAnchor),
            bgHPBDConfetti.trailingAnchor.constraint(equalTo: gifView.trailingAnchor),
            bgHPBDConfetti.bottomAnchor.constraint(equalTo: gifView.bottomAnchor),
            bgHPBDConfetti.topAnchor.constraint(equalTo: gifView.topAnchor),
        ])
        
        guard let imageConfetti = UIImage.gif(name: "confetti",bundle: Bundle.resourceBundle(for: Self.self)) else
        {
            return
        }
        bgHPBDConfetti.image = imageConfetti
    }
    private func initGifView(withJsonGifName: String) -> Void {
        
        // start animaion JSON
        if let animation = LottieAnimation.named("withJsonGifName"){
            gifAnimationView.animation = animation
            gifAnimationView.contentMode = .scaleAspectFit
            gifView.addSubview(gifAnimationView)
            gifAnimationView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                gifAnimationView.leadingAnchor.constraint(equalTo: gifView.leadingAnchor),
                gifAnimationView.trailingAnchor.constraint(equalTo: gifView.trailingAnchor),
                gifAnimationView.bottomAnchor.constraint(equalTo: gifView.bottomAnchor),
                gifAnimationView.topAnchor.constraint(equalTo: gifView.topAnchor),
            ])
            
            gifAnimationView.play(
                fromProgress: 0,
                toProgress: 1,
                loopMode: .loop,
                completion: { (finished) in
                    if finished {
                        print("Animation finished")
                    } else {
                        print("Animation cancelled")
                    }
                })

        }else{
            let imageBGView = UIImageView(image: UIImage(named: ""))
            gifView.addSubview(imageBGView)
            imageBGView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageBGView.leadingAnchor.constraint(equalTo: gifView.leadingAnchor),
                imageBGView.trailingAnchor.constraint(equalTo: gifView.trailingAnchor),
                imageBGView.bottomAnchor.constraint(equalTo: gifView.bottomAnchor),
                imageBGView.topAnchor.constraint(equalTo: gifView.topAnchor),
            ])
            
        }
        
        
    }
    @IBAction func actionDismiss(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {[weak self] in
            self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {[weak self] in
                self?.callbackClose?()
            })
        }
    }
  
    @IBAction func actionGift(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {[weak self] in
            self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {[weak self] in
                self?.callbackReceivingGifts?()
            })
        }
    }
    
    
    
}
