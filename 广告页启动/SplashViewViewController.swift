//
//  SplashViewViewController.swift
//  广告页启动
//
//  Created by 文伟佳 on 2021/11/16.
//

import UIKit

class SplashViewViewController: UIViewController {
    
    var hasAds: Bool = false //是否有广告
    
    var imageFile: String?//图片文件路径
    
    var timer: DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        showAdViewIfNeed()
        gcdTime()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - ***** setUI *****
    func setUI() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        view.addSubview(bgImageView)
        view.addSubview(timeButton)
        
        //看公司需求展示大小
        bgImageView.frame = view.bounds
        timeButton.frame = CGRect(x: view.bounds.size.width - 110, y: 50, width: 80, height: 40)
    }
    
    //MARK: - ***** networkRequest *****
    func showAdViewIfNeed() {
        //广告路径
        let adFilePath = FileCache.shareInstance.adPath()
        // 文件名称
        let imageFileName = FileCache.shareInstance.filePath(adFilePath)
        
        if let _adFilePath = adFilePath, let _imageFileName = imageFileName {
            imageFile = _adFilePath + _imageFileName
            hasAds = true
          
            let dict = UserDefaults.standard.object(forKey: ADHelper.adImageKey) as! Dictionary<String, String>
            let url = dict[_imageFileName]
            
            //不用单例保存跳转链接也行，定义一个url也行
            ADHelper.shareInstance.lastADImageLinkUrl = url
        }
        
        DispatchQueue.main.async { [self] in
            if hasAds {
                //如果有广告图片，则显示广告图片
                bgImageView.image = UIImage(contentsOfFile: imageFile ?? "")
            } else {
                //看公司需求,
                // 没有广告,展示本地广告，没有本地广告，就跳转首页
                stopTimer()
                bgImageView.image = UIImage(named: "mm.jpeg")
            }
        }
    }
    
    //MARK: - ***** Action *****
    @objc func timeBtnClick() {
        goToHomePageAnimation()
    }
    
    @objc func adImageClick() {
        print("点击广告")
        let alertVC = UIAlertController(title: "点击广告", message: ADHelper.shareInstance.lastADImageLinkUrl, preferredStyle: .alert)
        let action = UIAlertAction(title: "好的", style: .default, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - ***** private *****
   private func goToHomePageAnimation() {
//        放大1.5倍消失，效果可以自己调式，也可以去掉
        UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState) {

            self.view.alpha = 0
            if self.hasAds {
                self.view.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0)
            }
        } completion: { _ in
            self.goToHomePage()
        }
       
       //单window效果
//       UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve) {
//       } completion: { _ in
//           self.goToHomePage()
//       }
    }
    
    private func goToHomePage() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let splashWindow = delegate.splashWindow
        if (splashWindow != nil) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:KEY_NOTIFY_CHANGE_KEY_WINDOW), object: nil)
        }
    }
    
   private func gcdTime() {
        var timeCount = 5
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        timer?.setEventHandler(handler: {
            // 每秒计时一次
            timeCount = timeCount - 1
            DispatchQueue.main.async {
                // 时间到了取消时间源
                if timeCount <= 0 {
                    self.stopTimer()
                    self.goToHomePageAnimation()
                }else {
                    self.timeButton.setTitle("跳过(\(timeCount)s)", for: .normal)
                }
            }
           
        })
        // 启动时间源
        timer?.resume()
    }
    
    //停止定时器
    private func stopTimer() {
        print("定时器结束")
        timer?.cancel()
        timer = nil
    }
    
    //MARK: - ***** 懒加载 *****
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(adImageClick))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    lazy var timeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(timeBtnClick), for: .touchUpInside)
        return button
    }()
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
