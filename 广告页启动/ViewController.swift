//
//  ViewController.swift
//  广告页启动
//
//  Created by 文伟佳 on 2021/11/16.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemPink
        self.title = "首页"
        requestADURL()
        // Do any additional setup after loading the view.
    }

    
    /// 请求广告图
    func requestADURL() {
        
        // 模拟数据1秒后进行
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            
            //获取广告目录
            let adsDir = FileCache.shareInstance.adPath()!
            
            /**模拟每次获取不同的广告图**/
            var imageName = "mm2.jpeg"
            let fileName = FileCache.shareInstance.filePath(adsDir)
            if fileName == imageName {
                imageName = "mm.jpeg"
                //这里明显可以看到网络图片和本地缓存的是一样的，就可以不处理，直接return
            }
            
            //imageName的数据后台不一定每次返回都有，没有的话清空目录后，也可以return了
            
            // 清空目录的内容
            FileCache.shareInstance.clearPath(adsDir)
            
            // 拼接图片路径
            let saveFilePath = adsDir + imageName
            
            //下载图片,保存data,这么用模拟获取data
            let image = UIImage(named: imageName)
            let data = image?.jpegData(compressionQuality: 1.0)

            
            // 将图片写到指定目录
            let isScu = FileManager.default.createFile(atPath: saveFilePath, contents: data, attributes: nil)
            print("是否成功存储：\(isScu)")
            
            // 模拟跳转链接，正常是后台返回
            let link = "www.baidu.com"
            let dict = [imageName: link]
            //保存的字典，文件名称为key, link为value，如果有其它数据需要存储，也可以写在字典里面
            UserDefaults.standard.set(dict, forKey: ADHelper.adImageKey)
        }
    }
}

