//
//  ViewController.m
//  UniSDKDemoForOc
//
//  Created by 候文福 on 2022/9/22.
//

#import "ViewController.h"
#import "USO_UniMpManager.h"

@interface ViewController ()<USO_UniMpManagerDelegate>

@property (nonatomic, strong) UIButton *enterUniMpBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"模拟启动小程序";
//    初始化数据库
    [[DBManager shareManager] createTable];
//    配置uni小程序
    [[USO_UniMpManager sharedManager] setDelegate:self];
    [[USO_UniMpManager sharedManager] setUniMPMenuItems:@[]];
    
    [self.enterUniMpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
}

/// 进入小程序
- (void)enterUniMp{
    
    NSString *appid = [[USO_UniMpManager sharedManager] getActiveUniMPAppid];
    if (appid.length > 0) {
        [[USO_UniMpManager sharedManager] showUniMP];
    }else{
        NSDictionary *uniDic = @{
            @"uniAppId":@"__UNI__1F141E6",
            @"fileUrl":@"",
            @"version":@"",
            @"localPath":@""
        };
        USO_GSGztModel *model = [USO_GSGztModel setValueWithDic:uniDic];
        [self checkUpdateWithModel:model];
    }
}

// 检测更新和版本是否存在
- (void)checkUpdateWithModel:(USO_GSGztModel *)model{
    NSString *version = model.version;
    NSString *appId = model.uniAppId;
    
    USO_GSGztModel *dbModel = [[DBManager shareManager] searchUniApModelWithUniAppId:appId];
    if (dbModel) {
        if (![dbModel.version isEqualToString:version]) {
            NSString *msg = [NSString stringWithFormat:@"发现%@新版本：%@", dbModel.appName, model];
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(self) weakSelf = self;
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续使用" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf openUniMP:appId path:dbModel.localPath];
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:dbModel.localPath]) {
                    [[NSFileManager defaultManager] removeItemAtPath:dbModel.localPath error:nil];
                }
                
                [self downloadUniMp:dbModel];
                
            }];
            [alertVc addAction:cancelAction];
            [alertVc addAction:okAction];
            [self.navigationController presentViewController:alertVc animated:YES completion:nil];
        }else{
            [self startUniMp:dbModel];
        }
        
    }else{
        NSString *appResourcePath =  [[NSBundle mainBundle] pathForResource:appId ofType:@"wgt"];
        if (appResourcePath == nil || appResourcePath.length == 0) {
            NSLog(@"当前无小程序文件");
            [self downloadUniMp:model];
            return;
        }
        model.localPath = appResourcePath;
        
        [self startUniMp:model];
    }
}

// 下载小程序
- (void)downloadUniMp:(USO_GSGztModel *)model{
    if (!(model.fileUrl.length > 0 && model.uniAppId.length > 0)) {
        NSLog(@"下载地址或小程序id为空");
        return;
    }
    __block USO_GSGztModel *tempModel = model;
    __weak typeof(self) weakSelf = self;
    [[USO_UniDataManager alloc] downloadWithUrl:model.fileUrl uniMp:model.uniAppId complate:^(id  _Nonnull result, NSError * _Nonnull error) {
        if (error) {
            [TostaObject makeToast:error.localizedDescription];
        }else{
            tempModel.localPath = result;
            [weakSelf startUniMp:tempModel];
        }
    }];
}

// 同步数据并启动小程序
- (void)startUniMp:(USO_GSGztModel *)model{
    // 插入本地数据库
//    [[DBManager shareManager] insertUniAppModel:model];
    [self openUniMP:model.uniAppId path:model.localPath];
}

// 启动小程序
- (void)openUniMP:(NSString *)appid path:(NSString *)path{
    if (appid.length == 0) {
        [TostaObject makeToast:@"当前小程序id未设置"];
        return;
    }
    
    if([[USO_UniMpManager sharedManager] checkUniMPResource:appid path:path]){
        [[USO_UniMpManager sharedManager] openUniMP:appid redirectPath:path completed:^(DCUniMPInstance * _Nullable uniMPInstance, NSError * _Nullable error) {
            
        }];
    }
}

#pragma mark - USO_UniMpManagerDelegate

#pragma mark - lazy
- (UIButton *)enterUniMpBtn{
    if (!_enterUniMpBtn) {
        _enterUniMpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterUniMpBtn setTitle:@"进入小程序" forState:normal];
        [_enterUniMpBtn setTitleColor:UIColor.blueColor forState:normal];
        [_enterUniMpBtn addTarget:self action:@selector(enterUniMp) forControlEvents:UIControlEventTouchUpInside];
        _enterUniMpBtn.layer.cornerRadius = 10;
        _enterUniMpBtn.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _enterUniMpBtn.layer.borderWidth = 1;
        [self.view addSubview:_enterUniMpBtn];
    }
    return _enterUniMpBtn;
}

@end
