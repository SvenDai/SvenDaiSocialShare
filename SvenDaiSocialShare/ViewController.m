//
//  ViewController.m
//  SvenDaiSocialShare
//
//  Created by daifeng on 2017/5/2.
//  Copyright © 2017年 daifeng. All rights reserved.
//

#import "ViewController.h"
#import "ActionSheetView.h"
#import "WXApiManager.h"
#import "UIAlertView+WX.h"
#import "WechatAuthSDK.h"
#import "WXApiRequestHandler.h"
#import "Constant.h"

@interface ViewController ()<WXApiManagerDelegate,UITextViewDelegate,WechatAuthAPIDelegate>

@property (nonatomic) enum WXScene currentScene;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [WXApiManager sharedManager].delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ShareBtnClick:(id)sender {
    //    NSArray *titlearr = @[@"微信朋友圈",@"微信好友",@"微信朋友圈",@"微信好友",@"微信朋友圈",@"微信好友",@"微信朋友圈",@"微信好友",@"微信朋友圈"];
    //    NSArray *imageArr = @[@"wechatquan",@"wechat",@"tcentQQ",@"tcentkongjian",@"wechatquan",@"wechat",@"wechatquan",@"wechat",@"tcentQQ"];
    NSArray *titlearr = @[@"微信朋友圈",@"微信好友",@"QQ",@"复制链接"];
    NSArray *imageArr = @[@"wechatquan",@"wechat",@"tcentQQ",@"copyUrl"];
    
    ActionSheetView *actionsheet = [[ActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"测试" and:ShowTypeIsShareStyle];
    [actionsheet setBtnClick:^(NSInteger btnTag) {
        switch (btnTag) {
            case 0:
                NSLog(@"点击了微信朋友圈！");
                _currentScene = WXSceneTimeline;
                
                [self sendLinkContent];
                break;
            case 1:
                _currentScene = WXSceneSession;
                NSLog(@"点击了微信好友！");
                [self sendLinkContent];
                break;
            case 2:
                _currentScene = WXSceneFavorite;
                NSLog(@"点击了收藏");
                [self sendLinkContent];
                
                break;
            case 3:
                [self copyUrltoPasteboard];
                NSLog(@"点击了复制链接");
                break;
            default:
                break;
        }
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
}


#pragma mark - Action
- (void) copyUrltoPasteboard{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = kLinkURL;
}

- (void)sendTextContent {
    [WXApiRequestHandler sendText:kTextMessage
                          InScene:_currentScene];
}

- (void)sendImageContent {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res1" ofType:@"jpg"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    
    UIImage *thumbImage = [UIImage imageNamed:@"res1thumb.png"];
    [WXApiRequestHandler sendImageData:imageData
                               TagName:kImageTagName
                            MessageExt:kMessageExt
                                Action:kMessageAction
                            ThumbImage:thumbImage
                               InScene:_currentScene];
}

- (void)sendLinkContent {
    UIImage *thumbImage = [UIImage imageNamed:@"res2.png"];
    NSLog(@"SendMsgToWeChatViewController|sendLinkContent");
    [WXApiRequestHandler sendLinkURL:kLinkURL
                             TagName:kLinkTagName
                               Title:kLinkTitle
                         Description:kLinkDescription
                          ThumbImage:thumbImage
                             InScene:_currentScene];
}

- (void)sendMusicContent {
    UIImage *thumbImage = [UIImage imageNamed:@"res3.jpg"];
    [WXApiRequestHandler sendMusicURL:kMusicURL
                              dataURL:kMusicDataURL
                                Title:kMusicTitle
                          Description:kMusicDescription
                           ThumbImage:thumbImage
                              InScene:_currentScene];
}

- (void)sendAppBrand{
    UIImage *thumbImage = [UIImage imageNamed:@"res3.jpg"];
    
    [UIAlertView requestWithTitle:@"brandUserName" message:nil defaultText:@"gh_d43f693ca31f" sure:^(UIAlertView *alertView, NSString *text) {
        NSString *brandUserName = text;
        [UIAlertView requestWithTitle:@"brandPath" message:nil defaultText:nil sure:^(UIAlertView *alertView, NSString *text) {
            NSString *brandPath = text;
            [UIAlertView requestWithTitle:@"url" message:nil defaultText:@"https://www.baidu.com" sure:^(UIAlertView *alertView, NSString *text) {
                NSString *webUrl = text;
                [WXApiRequestHandler sendMiniProgramWebpageUrl:webUrl
                                                      userName:brandUserName
                                                          path:brandPath
                                                         title:kMiniProgramTitle
                                                   Description:kMiniProgramDesc
                                                    ThumbImage:thumbImage
                                                       InScene:_currentScene];
            }];
        }];
    }];
}

- (void)sendVideoContent {
    UIImage *thumbImage = [UIImage imageNamed:@"res7.jpg"];
    [WXApiRequestHandler sendVideoURL:kVideoURL
                                Title:kVideoTitle
                          Description:kVideoDescription
                           ThumbImage:thumbImage
                              InScene:_currentScene];
}

- (void)sendAppContent {
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    UIImage *thumbImage = [UIImage imageNamed:@"res2.jpg"];
    [WXApiRequestHandler sendAppContentData:data
                                    ExtInfo:kAppContentExInfo
                                     ExtURL:kAppContnetExURL
                                      Title:kAPPContentTitle
                                Description:kAPPContentDescription
                                 MessageExt:kAppMessageExt
                              MessageAction:kAppMessageAction
                                 ThumbImage:thumbImage
                                    InScene:_currentScene];
}

- (void)sendNonGifContent {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5"
                                                         ofType:@"jpg"];
    NSData *emoticonData = [NSData dataWithContentsOfFile:filePath];
    
    UIImage *thumbImage = [UIImage imageNamed:@"res5thumb.png"];
    [WXApiRequestHandler sendEmotionData:emoticonData
                              ThumbImage:thumbImage
                                 InScene:_currentScene];
}

- (void)sendGifContent {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res6"
                                                         ofType:@"gif"];
    NSData *emoticonData = [NSData dataWithContentsOfFile:filePath];
    
    UIImage *thumbImage = [UIImage imageNamed:@"res6thumb.png"];
    [WXApiRequestHandler sendEmotionData:emoticonData
                              ThumbImage:thumbImage
                                 InScene:_currentScene];
}

- (void)sendAuthRequest {
    [WXApiRequestHandler sendAuthRequestScope: kAuthScope
                                        State:kAuthState
                                       OpenID:kAuthOpenID
                             InViewController:self];
}

- (void)sendFileContent {
    UIImage *thumbImage = [UIImage imageNamed:@"res2.jpg"];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:kFileName
                                                         ofType:kFileExtension];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    [WXApiRequestHandler sendFileData:fileData
                        fileExtension:kFileExtension
                                Title:kFileTitle
                          Description:kFileDescription
                           ThumbImage:thumbImage
                              InScene:_currentScene];
}

- (void)addCardToWXCardPackage {
    NSDictionary *extDic = @{
                             @"code":@"",
                             @"openid":@"",
                             @"timestamp":@"1418301401",
                             @"signature":@"ad9cf9463610bc8752c95084716581d52cd33aa0"
                             };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *extStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [WXApiRequestHandler addCardsToCardPackage:@[@"pDF3iY9tv9zCGCj4jTXFOo1DxHdo"] cardExts:@[extStr]];
}

- (void)batchAddCardToWXCardPackage {
    NSDictionary *extDic = @{
                             @"code":@"",
                             @"openid":@"",
                             @"timestamp":@"1418301401",
                             @"signature":@"ad9cf9463610bc8752c95084716581d52cd33aa0"
                             };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *extStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [WXApiRequestHandler addCardsToCardPackage:@[@"pDF3iY9tv9zCGCj4jTXFOo1DxHdo",
                                                 @"pDF3iY9tv9zCGCj4jTXFOo1DxHdo"]
                                      cardExts:@[extStr,[extStr copy]]];
}

- (void)chooseCard {
    [WXApiRequestHandler chooseCard:@"wxf8b4f85f3a794e77"
                           cardSign:@"6caa49f4a5af3d64ac247e1f563e5b5eb94619ad"
                           nonceStr:@"k0hGdSXKZEj3Min5"
                           signType:@"SHA1" timestamp:1437997723];
}

- (void)chooseInvoiceTicket
{
    [WXApiRequestHandler chooseInvoice:@"wx0673f9fda880509e"
                              cardSign:@""
                              nonceStr:@""
                              signType:@"SHA1"
                             timestamp:[@"" intValue]];
}

#pragma mark -WechatAuthAPIDelegate
//得到二维码
- (void)onAuthGotQrcode:(UIImage *)image
{
    NSLog(@"onAuthGotQrcode");
}

//二维码被扫描
- (void)onQrcodeScanned
{
    NSLog(@"onQrcodeScanned");
}

//成功登录
- (void)onAuthFinish:(int)errCode AuthCode:(NSString *)authCode
{
    NSLog(@"onAuthFinish");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"onAuthFinish"
                                                    message:[NSString stringWithFormat:@"authCode:%@ errCode:%d", authCode, errCode]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - WXApiManagerDelegate
//- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)req {
//    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
//    NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
//    NSString *strMsg = [NSString stringWithFormat:@"openID: %@", req.openID];
//    [UIAlertView showWithTitle:strTitle message:strMsg sure:^(UIAlertView *alertView, NSString *text) {
//        RespForWeChatViewController* controller = [[RespForWeChatViewController alloc] init];
//        [self presentViewController:controller animated:YES completion:nil];
//    }];
//}

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)req {
    WXMediaMessage *msg = req.message;
    
    //显示微信传过来的内容
    NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
    NSString *strMsg = nil;
    
    if ([msg.mediaObject isKindOfClass:[WXAppExtendObject class]]) {
        WXAppExtendObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n附带信息：%@ \n文件大小:%lu bytes\n附加消息:%@\n", req.openID, msg.title, msg.description, obj.extInfo, (unsigned long)obj.fileData.length, msg.messageExt];
    }
    else if ([msg.mediaObject isKindOfClass:[WXTextObject class]]) {
        WXTextObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n内容：%@\n", req.openID, msg.title, msg.description, obj.contentText];
    }
    else if ([msg.mediaObject isKindOfClass:[WXImageObject class]]) {
        WXImageObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n图片大小:%lu bytes\n", req.openID, msg.title, msg.description, (unsigned long)obj.imageData.length];
    }
    else if ([msg.mediaObject isKindOfClass:[WXLocationObject class]]) {
        WXLocationObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n经纬度：lng:%f_lat:%f\n", req.openID, msg.title, msg.description, obj.lng, obj.lat];
    }
    else if ([msg.mediaObject isKindOfClass:[WXFileObject class]]) {
        WXFileObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n文件类型：%@ 文件大小:%lu\n", req.openID, msg.title, msg.description, obj.fileExtension, (unsigned long)obj.fileData.length];
    }
    else if ([msg.mediaObject isKindOfClass:[WXWebpageObject class]]) {
        WXWebpageObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n网页地址：%@\n", req.openID, msg.title, msg.description, obj.webpageUrl];
    }
    //[UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)req {
    //WXMediaMessage *msg = req.message;
    
    //从微信启动App
    //NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
    //NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", req.openID, msg.messageExt];
    //[UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    NSLog(@"managerDidRecvMessageResponse: %@",@"发送媒体消息结果");
    NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
    [UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response {
    NSMutableString* cardStr = [[NSMutableString alloc] init];
    for (WXCardItem* cardItem in response.cardAry) {
        [cardStr appendString:[NSString stringWithFormat:@"code:%@ cardid:%@ cardext:%@ cardstate:%u\n",cardItem.encryptCode,cardItem.cardId,cardItem.extMsg,(unsigned int)cardItem.cardState]];
    }
    //[UIAlertView showWithTitle:@"add card resp" message:cardStr sure:nil];
}

- (void)managerDidRecvChooseCardResponse:(WXChooseCardResp *)response {
    NSMutableString* cardStr = [[NSMutableString alloc] init];
    for (WXCardItem* cardItem in response.cardAry) {
        [cardStr appendString:[NSString stringWithFormat:@"cardid:%@, encryptCode:%@, appId:%@\n",cardItem.cardId,cardItem.encryptCode,cardItem.appID]];
    }
    //[UIAlertView showWithTitle:@"choose card resp" message:cardStr sure:nil];
}

- (void)managerDidRecvChooseInvoiceResponse:(WXChooseInvoiceResp *)response {
    NSMutableString* cardStr = [[NSMutableString alloc] init];
    for (WXInvoiceItem* cardItem in response.cardAry) {
        [cardStr appendString:[NSString stringWithFormat:@"cardid:%@, encryptCode:%@, appId:%@\n",cardItem.cardId,cardItem.encryptCode,cardItem.appID]];
    }
    //[UIAlertView showWithTitle:@"choose invoice resp" message:cardStr sure:nil];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    //NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
    //NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    
    //[UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}


@end
