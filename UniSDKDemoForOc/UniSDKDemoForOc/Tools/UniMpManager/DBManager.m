//
//  DBManager.m
//  App
//
//  Created by 张杨 on 2019/11/22.
//

#import "DBManager.h"
#import "FMDB.h"

NSString * const kDBName = @"db.sqlite";
static FMDatabase *_db;


@interface DBManager()

@end

@implementation DBManager

+ (instancetype)shareManager
{
    static DBManager *manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[DBManager alloc] init];
    });
    
    return manger;
    
}

+ (void)initialize
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqliteFile = [documentPath stringByAppendingPathComponent:kDBName];
    _db = [FMDatabase databaseWithPath:sqliteFile];
    _db.traceExecution = YES;
}

#pragma mark - create 'Table'
- (void)createTable {
    
    if (![_db open]) {
        return;
    }
    
    //BOOL isSuccess = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS T_CACHE (id INTEGER PRIMARY KEY AUTOINCREMENT,cache_data blob not null,cache_key text)"];
    BOOL isSuccess = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS T_CACHE (id INTEGER PRIMARY KEY AUTOINCREMENT,appName text NOT NULL,uniAppId text NOT NULL,version text NOT NULL,localPath text NOT NULL,fileUrl text NOT NULL)"];
    
    if (isSuccess) {
        
        NSLog(@"---------------------");
        NSLog(@" create table success");
        NSLog(@"---------------------");
    }else{
        
        NSLog(@"-------------------");
        NSLog(@" create table faild");
        NSLog(@"-------------------");
    }
}

#pragma mark - 根据小程序唯一ID查询
/**根据小程序唯一ID查询*/
- (USO_GSGztModel *)searchUniApModelWithUniAppId:(NSString *)uniAppId
{
    if (![_db open] || uniAppId.length==0) {
        return nil;
    }
    FMResultSet *result = [_db executeQueryWithFormat:@"SELECT * FROM T_CACHE WHERE uniAppId = %@",uniAppId];
    
    while ([result next]) {
        USO_GSGztModel *model = [[USO_GSGztModel alloc] init];
        
        model.appName = [result stringForColumn:@"appName"];
        model.fileUrl = [result stringForColumn:@"fileUrl"];
        model.localPath = [result stringForColumn:@"localPath"];
        model.version = [result stringForColumn:@"version"];
        model.uniAppId = [result stringForColumn:@"uniAppId"];
        
        NSLog(@"从数据库查询到的模块 %@[%@][%@]",model.appName,model.uniAppId,model.version);
        return model;
    }
    
    return nil;
}

/**插入小程序信息*/
- (void)insertUniAppModel:(USO_GSGztModel *)model
{
    if (![_db open]) {
        return;
    }
    
    //先查询
    USO_GSGztModel *oldModel = [self searchUniApModelWithUniAppId:model.uniAppId];
    
    if (oldModel) {
        //执行更新操作
        [self updateUniApModelWithUniAppId:model];
    }
    else
    {
        NSString *appName = model.appName.length?model.appName:@"";
        NSString *uniAppId = model.uniAppId.length?model.uniAppId:@"";
        NSString *version = model.version.length?model.version:@"";
        NSString *localPath = model.localPath.length?model.localPath:@"";
        NSString *fileUrl = model.fileUrl.length?model.fileUrl:@"";
        
        BOOL result = [_db executeUpdateWithFormat:@"INSERT INTO T_CACHE (appName,uniAppId,version,localPath,fileUrl) VALUES (%@,%@,%@,%@,%@)",appName,uniAppId,version,localPath,fileUrl];
        
        if (result) {
            NSLog(@"insert into 'T_CACHE' success");
            
        } else {
            NSLog(@"insert into 'T_CACHE' faile");
        }
        
        [_db close];
    }
}

/**更新小程序信息*/
- (void)updateUniApModelWithUniAppId:(USO_GSGztModel *)model
{
    if (![_db open]) {
        return;
    }
    
    //NSString *appName = model.appName.length?model.appName:@"";
    NSString *uniAppId = model.uniAppId.length?model.uniAppId:@"";
    NSString *version = model.version.length?model.version:@"";
    //NSString *localPath = model.localPath.length?model.localPath:@"";
    //NSString *fileUrl = model.fileUrl.length?model.fileUrl:@"";
    
    BOOL result = [_db executeUpdate:@"update 'T_CACHE' set version = ? where uniAppId = ?" withArgumentsInArray:@[version,uniAppId]];
    if (result) {
        NSLog(@"update 'T_CACHE' success");
        
    } else {
        NSLog(@"update 'T_CACHE' failure");
    }
    
    [_db close];
}


#pragma mark - insert data
- (void)insertItem:(id)item cacheKey:(NSString *)cacheKey {
    
    if (![_db open]) {
        return;
    }
    
    if(![self itemWithCacheKey:cacheKey])
    {
        NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:item];
        BOOL isSuccess = [_db executeUpdateWithFormat:@"INSERT INTO T_CACHE (cache_data,cache_key) VALUES (%@,%@)",cacheData,cacheKey];
        if (isSuccess) {
            NSLog(@"---------------");
            NSLog(@" insert success");
            NSLog(@"---------------");
        }else{
            NSLog(@"-------------");
            NSLog(@" insert faild");
            NSLog(@"-------------");
        }
    }else
    {
        NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:item];
        BOOL isSuccess = [_db executeUpdateWithFormat:@"UPDATE T_CACHE SET cache_data = %@ WHERE cache_key = %@",cacheData,cacheKey];
        if (isSuccess) {
            NSLog(@"---------------");
            NSLog(@" UPDATE success");
            NSLog(@"---------------");
        }else{
            NSLog(@"-------------");
            NSLog(@" UPDATE faild");
            NSLog(@"-------------");
        }
    }
}

- (id)itemWithCacheKey:(NSString *)cacheKey {
    
    if (![_db open] || !cacheKey) {
        return nil;
    }
    FMResultSet *rs = [_db executeQueryWithFormat:@"SELECT * FROM T_CACHE WHERE cache_key = %@",cacheKey];
    while ([rs next]) {
        NSData *data = [rs dataForColumn:@"cache_data"];
        id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return obj;
    }
    return nil;
}


#pragma mark - clear all data
- (void)clearAll {
    
    if (![_db open]) {
        return;
    }
    
    [_db executeUpdate:@"DELETE FROM T_CACHE"];
    
    [_db close];
}

- (NSString *)getDBPath {
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dbPath = [documentPath stringByAppendingPathComponent:kDBName];
    return dbPath;
}


@end
