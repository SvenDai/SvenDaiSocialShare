# SvenDaiSocialShare 微信分享组件

![image](https://github.com/SvenDai/SvenDaiSocialShare/blob/master/ScreenShots/function.png)

结合了微信官方的分享接入指南的Demo

https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=&lang=zh_CN

和开源UI

https://github.com/GeekZP/ZPActionSheet

做了整合并加入拷贝URL功能


1、需要按照微信官方的接入指南进行相应的配置

	a、导入如下几个库

	![image](https://github.com/SvenDai/SvenDaiSocialShare/blob/master/ScreenShots/lib.png)
	
	b、在appdelagete.m中向微信注册appid（在微信开放平台申请获得）,设置微信返回app时的handleopenurl

	c、在info中添加一条url scheme
	
	![image](https://github.com/SvenDai/SvenDaiSocialShare/blob/master/ScreenShots/urltype.png)

	d、在Other Link Flags 中加入 -Objc 和-all_load
