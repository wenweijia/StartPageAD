//
//  ADHelper.swift
//  广告页启动
//
//  Created by 文伟佳 on 2021/11/16.
//

import Foundation


class ADHelper {
    static let shareInstance = ADHelper()
    private init(){}
    
    static let adImageKey = "kAppStartImageSaveKey"
    
    /// 图片跳转链接
    var lastADImageLinkUrl: String?
    
}
