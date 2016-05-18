//
//  Networking.m
//  AFNetworking-3.x
//
//  Created by YouXianMing on 16/3/12.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import "Networking.h"
#import "AFNetworking.h"

@interface Networking ()

@property (nonatomic, strong) AFHTTPRequestOperationManager  *manager;
@property (nonatomic, strong) AFHTTPRequestOperation         *httpOperation;

@end

@implementation Networking

- (void)setup {
    
    [super setup];
    
    // AFNetworking 2.x 相关初始化
    self.manager = [AFHTTPRequestOperationManager manager];
}

- (void)startRequest {
    
    NSParameterAssert(self.urlString);
    NSParameterAssert(self.requestParameterSerializer);
    NSParameterAssert(self.responseDataSerializer);
    
    [self resetData];
    [self accessRequestSerializer];
    [self accessResponseSerializer];
    [self accessHeaderField];
    [self accessTimeoutInterval];
    
    if ([self.method isKindOfClass:[GetMethod class]]) {
        
        [self accessGetRequest];
        
    } else if ([self.method isKindOfClass:[PostMethod class]]) {
        
        [self accessPostRequest];
        
    } else if ([self.method isKindOfClass:[UploadMethod class]]) {
        
        [self accessUploadRequest];
    }
    
    [self safetySetKey:@"absoluteString"         object:self.httpOperation.request.URL.absoluteString];
    [self safetySetKey:@"host"                   object:self.httpOperation.request.URL.host];
    [self safetySetKey:@"query"                  object:self.httpOperation.request.URL.query];
    [self safetySetKey:@"scheme"                 object:self.httpOperation.request.URL.scheme];
    [self safetySetKey:@"timeoutInterval"        object:@(self.httpOperation.request.timeoutInterval)];
    [self safetySetKey:@"allHTTPHeaderFields"    object:self.httpOperation.request.allHTTPHeaderFields];
    [self safetySetKey:@"acceptableContentTypes" object:self.manager.responseSerializer.acceptableContentTypes];
    [self safetySetKey:@"parameter"              object:self.requestParameter];
}

- (void)safetySetKey:(NSString *)key object:(id)object {
    
    if (object) {
        
        [self.networkingInfomation setObject:object forKey:key];
    }
}

- (void)cancelRequest {
    
    [self.httpOperation cancel];
}

- (void)accessGetRequest {
    
    self.isRunning              = YES;
    __weak Networking *weakSelf = self;
    
    self.httpOperation = [self.manager GET:self.urlString
                                parameters:[self.requestParameterSerializer serializeRequestParameter:self.requestParameter]
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                       weakSelf.isRunning              = NO;
                                       weakSelf.originalResponseData   = responseObject;
                                       weakSelf.serializerResponseData = [weakSelf.responseDataSerializer serializeResponseData:responseObject];
                                       
                                       if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSucess:data:)]) {
                                           
                                           [weakSelf.delegate requestSucess:weakSelf data:weakSelf.serializerResponseData];
                                       }
                                       
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       weakSelf.isRunning = NO;
                                       
                                       if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                                           
                                           [weakSelf.delegate requestFailed:weakSelf error:error];
                                       }
                                   }];
}

- (void)accessPostRequest {
    
    self.isRunning              = YES;
    __weak Networking *weakSelf = self;
    
    self.httpOperation = [self.manager POST:self.urlString
                                 parameters:[self.requestParameterSerializer serializeRequestParameter:self.requestParameter]
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        weakSelf.isRunning              = NO;
                                        weakSelf.originalResponseData   = responseObject;
                                        weakSelf.serializerResponseData = [weakSelf.responseDataSerializer serializeResponseData:responseObject];
                                        
                                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSucess:data:)]) {
                                            
                                            [weakSelf.delegate requestSucess:weakSelf data:weakSelf.serializerResponseData];
                                        }
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                        weakSelf.isRunning = NO;
                                        
                                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                                            
                                            [weakSelf.delegate requestFailed:weakSelf error:error];
                                        }
                                    }];
}

- (void)accessUploadRequest {
    
    self.isRunning              = YES;
    __weak Networking *weakSelf = self;
    
    self.httpOperation = [self.manager POST:self.urlString
                                 parameters:[self.requestParameterSerializer serializeRequestParameter:self.requestParameter]
                  constructingBodyWithBlock:weakSelf.constructingBodyBlock
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        weakSelf.isRunning              = NO;
                                        weakSelf.originalResponseData   = responseObject;
                                        weakSelf.serializerResponseData = [weakSelf.responseDataSerializer serializeResponseData:responseObject];
                                        
                                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSucess:data:)]) {
                                            
                                            [weakSelf.delegate requestSucess:weakSelf data:weakSelf.serializerResponseData];
                                        }
                                        
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                        weakSelf.isRunning = NO;
                                        
                                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                                            
                                            [weakSelf.delegate requestFailed:weakSelf error:error];
                                        }
                                    }];
}

/**
 *  重置数据
 */
- (void)resetData {
    
    self.originalResponseData   = nil;
    self.serializerResponseData = nil;
}

/**
 *  处理请求body类型
 */
- (void)accessRequestSerializer {
    
    if ([self.requestBodyType isKindOfClass:[HttpBodyType class]]) {
        
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
    } else if ([self.requestBodyType isKindOfClass:[JsonBodyType class]]) {
        
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
    } else if ([self.requestBodyType isKindOfClass:[PlistBodyType class]]) {
        
        self.manager.requestSerializer = [AFPropertyListRequestSerializer serializer];
        
    } else {
        
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
}

/**
 *  处理回复data类型
 */
- (void)accessResponseSerializer {
    
    if ([self.responseDataType isKindOfClass:[HttpDataType class]]) {
        
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    } else if ([self.responseDataType isKindOfClass:[JsonDataType class]]) {
        
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
    } else {
        
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    self.manager.responseSerializer.acceptableContentTypes = [self.manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    self.manager.responseSerializer.acceptableContentTypes = [self.manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
}

/**
 *  处理请求头部信息
 */
- (void)accessHeaderField {
    
    if (self.HTTPHeaderFieldsWithValues) {
        
        NSArray *allKeys = self.HTTPHeaderFieldsWithValues.allKeys;
        
        for (NSString *headerField in allKeys) {
            
            NSString *value = [self.HTTPHeaderFieldsWithValues valueForKey:headerField];
            [self.manager.requestSerializer setValue:value forHTTPHeaderField:headerField];
        }
    }
}

/**
 *  设置超时时间
 */
- (void)accessTimeoutInterval {
    
    if (self.timeoutInterval && self.timeoutInterval.floatValue > 0) {
        
        [self.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.manager.requestSerializer.timeoutInterval = self.timeoutInterval.floatValue;
        [self.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
}

+ (id)getMethodNetworkingWithUrlString:(NSString *)urlString
                      requestParameter:(id)requestParameter
                       requestBodyType:(RequestBodyType *)requestBodyType
                      responseDataType:(ResponseDataType *)responseDataType {
    
    Networking *networking      = [[Networking alloc] init];
    networking.urlString        = urlString;
    networking.requestParameter = requestParameter;
    
    if (requestBodyType) {
        
        networking.requestBodyType = requestBodyType;
    }
    
    if (responseDataType) {
        
        networking.responseDataType = responseDataType;
    }
    
    return networking;
}

+ (id)postMethodNetworkingWithUrlString:(NSString *)urlString
                       requestParameter:(id)requestParameter
                        requestBodyType:(RequestBodyType *)requestBodyType
                       responseDataType:(ResponseDataType *)responseDataType {
    
    Networking *networking      = [[Networking alloc] init];
    networking.urlString        = urlString;
    networking.requestParameter = requestParameter;
    networking.method            = [PostMethod type];
    
    if (requestBodyType) {
        
        networking.requestBodyType = requestBodyType;
    }
    
    if (responseDataType) {
        
        networking.responseDataType = responseDataType;
    }
    
    return networking;
}

+ (id)uploadMethodNetworkingWithUrlString:(NSString *)urlString
                         requestParameter:(id)requestParameter
                          requestBodyType:(RequestBodyType *)requestBodyType
                         responseDataType:(ResponseDataType *)responseDataType
                constructingBodyWithBlock:(AFNetworkingConstructingBodyBlock)constructingBodyBlock
                                 progress:(UploadProgressBlock)uploadProgressBlock {
    
    Networking *networking           = [[Networking alloc] init];
    networking.urlString             = urlString;
    networking.requestParameter      = requestParameter;
    networking.method                = [UploadMethod type];
    networking.constructingBodyBlock = constructingBodyBlock;
    networking.uploadProgressBlock   = uploadProgressBlock;
    
    if (requestBodyType) {
        
        networking.requestBodyType = requestBodyType;
    }
    
    if (responseDataType) {
        
        networking.responseDataType = responseDataType;
    }
    
    return networking;
}

@end
