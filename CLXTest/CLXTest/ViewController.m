//
//  ViewController.m
//  CLXTest
//
//  Created by chen liangxiu on 2017/10/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "ViewController.h"
#import "CLXTableViewController.h"
#import "CLXNibView.h"
@import CLXBaseUtility;


void
__dispatch_once(dispatch_once_t *predicate,
               DISPATCH_NOESCAPE dispatch_block_t block)
{
    if (DISPATCH_EXPECT(*predicate, ~0l) != ~0l) {
        dispatch_once(predicate, block);
    } else {
        dispatch_compiler_barrier();
    }
    DISPATCH_COMPILER_CAN_ASSUME(*predicate == ~0l);
}

@interface ViewController ()<NSXMLParserDelegate>

@end

@implementation ViewController
{
    __weak NSString *w_str;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CLXKeychain *keychian = [CLXKeychain new];
    CLXKeychainItem *item = [CLXKeychainItem new];

    item.secAccount = @"liangxiu.chen";
    item.secServiceName = @"login";
    item.secData = [NSData dataWithData:[@"nihao" dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil;

    [keychian addKeychainItem:item error:&error];
    error = nil;
    item.secAccount = @"chen.liangxiu";
    CLXKeychainQuery *query = [CLXKeychainQuery new];
    query.accountForQuery = @"liangxiu.chen";
    query.serviceNameForQuery = @"login";
    [keychian updateKeyChainItem:item InQuery:query error:&error];
    query.accountForQuery = @"chen.liangxiu";
    __unused CLXKeychainItem *item1 = [keychian keychainItemForQuery:query error:&error];

    //timer
    CLXTimer *timer = [CLXTimer timer];
    timer.shouldReapt = YES;
    timer.interval = 1;
    [timer fireWithAction:^(CLXTimer *timer) {
        NSLog(@"%p",timer);
    } OnCancel:^(CLXTimer *timer) {
        NSLog(@"%p",timer);
    }];

    //nib
    UINib *aNib = [UINib nibWithNibName:@"CLXNibView" bundle:nil];
    [aNib instantiateWithOwner:nil options:nil];
    //xml
    NSString *xml = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    "<?xml-stylesheet type='text/css' href='cvslog.css'?>"
    "<!DOCTYPE cvslog SYSTEM \"cvslog.dtd\">"
    "<cvslog xmlns=\"http://xml.apple.com/cvslog\">"
    "<radar:radar xmlns:radar=\"http://xml.apple.com/radar\">"
    "<radar:bugID>2920186</radar:bugID>"
    "<radar:title>API/NSXMLParser: there ought to be an NSXMLParser</radar:title>"
    "</radar:radar>"
    "</cvslog>";
    const char *cstr = [xml cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:strlen(cstr)];
    NSXMLParser *parse = [[NSXMLParser alloc] initWithData: data];
    parse.delegate = self;
    BOOL status = [parse parse];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        <#code to be executed once#>
    });

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CLXTableViewController *tableViewController = [CLXTableViewController new];
    [self presentViewController:tableViewController animated:NO completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - parse delegate
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //
}

// DTD handling methods for various declarations.
- (void)parser:(NSXMLParser *)parser foundNotationDeclarationWithName:(NSString *)name publicID:(nullable NSString *)publicID systemID:(nullable NSString *)systemID
{

}

- (void)parser:(NSXMLParser *)parser foundUnparsedEntityDeclarationWithName:(NSString *)name publicID:(nullable NSString *)publicID systemID:(nullable NSString *)systemID notationName:(nullable NSString *)notationName
{

}

- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(nullable NSString *)type defaultValue:(nullable NSString *)defaultValue
{

}

- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model
{
    
}

- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(nullable NSString *)value
{

}

- (void)parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)name publicID:(nullable NSString *)publicID systemID:(nullable NSString *)systemID
{

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{

}
// sent when the parser finds an element start tag.
// In the case of the cvslog tag, the following is what the delegate receives:
//   elementName == cvslog, namespaceURI == http://xml.apple.com/cvslog, qualifiedName == cvslog
// In the case of the radar tag, the following is what's passed in:
//    elementName == radar, namespaceURI == http://xml.apple.com/radar, qualifiedName == radar:radar
// If namespace processing >isn't< on, the xmlns:radar="http://xml.apple.com/radar" is returned as an attribute pair, the elementName is 'radar:radar' and there is no qualifiedName.

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{

}
// sent when an end tag is encountered. The various parameters are supplied as above.

- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI
{

}
// sent when the parser first sees a namespace attribute.
// In the case of the cvslog tag, before the didStartElement:, you'd get one of these with prefix == @"" and namespaceURI == @"http://xml.apple.com/cvslog" (i.e. the default namespace)
// In the case of the radar:radar tag, before the didStartElement: you'd get one of these with prefix == @"radar" and namespaceURI == @"http://xml.apple.com/radar"

- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix
{

}
// sent when the namespace prefix in question goes out of scope.

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{

}
// This returns the string of the characters encountered thus far. You may not necessarily get the longest character run. The parser reserves the right to hand these to the delegate as potentially many calls in a row to -parser:foundCharacters:

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
{

}
// The parser reports ignorable whitespace in the same way as characters it's found.

- (void)parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(nullable NSString *)data
{

}
// The parser reports a processing instruction to you using this method. In the case above, target == @"xml-stylesheet" and data == @"type='text/css' href='cvslog.css'"

- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment
{

}
// A comment (Text in a <!-- --> block) is reported to the delegate as a single string

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{

}
// this reports a CDATA block to the delegate as an NSData.

- (nullable NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)name systemID:(nullable NSString *)systemID
{
    return nil;
}
// this gives the delegate an opportunity to resolve an external entity itself and reply with the resulting data.

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{

}
// ...and this reports a fatal error to the delegate. The parser will stop parsing.

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{

}
// If validation is on, this will report a fatal validation error to the delegate. The parser will stop parsing.

@end
