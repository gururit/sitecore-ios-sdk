#import "SCAsyncTestCase.h"

@interface FieldsErrorTest : SCAsyncTestCase
@end

@implementation FieldsErrorTest

-(void)testPagedFieldValueReaderWrongField
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* result_field_ = nil;
    __block SCError* field_error_ = nil;

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
    {
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName ];
        apiContext_ = strongContext_;

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.requestType = SCItemReaderRequestItemPath;
        request_.request     = SCHomePath;
        request_.pageSize    = 2;

        pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                      request: request_ ];
        [ pagedItems_ itemReaderForIndex: 0 ]( ^( id result_, NSError* error_ )
        {
            if ( !result_ )
            {
                did_finish_callback_();
                return;
            }
            [ result_ fieldValueReaderForFieldName: @"WrongField" ]( ^( id result_, NSError* error_ )
            {
                result_field_ = result_;
                field_error_ = (SCError*)error_;
                did_finish_callback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] != nil, @"OK" );
    GHAssertTrue( result_field_ == nil, @"OK" );
    GHAssertTrue( field_error_ != nil, @"OK" );
    GHAssertTrue( [ field_error_ isKindOfClass: [ SCNoFieldError class ] ] == TRUE, @"OK" );
}

-(void)testQueryFieldsReaderWrongFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSDictionary* result_fields_ = nil;
    
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
    {
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword];
        apiContext_ = strongContext_;
        
        NSSet* fields_ = [ NSSet setWithObjects: @"WrongField1", @"WrongField2", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.request = @"/sitecore/content/Home/descendant-or-self::*[@@templatename='Sample Item']";
        request_.requestType = SCItemReaderRequestQuery;
        request_.fieldNames = [ NSSet set ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_, NSError* error_ )
        {
            items_ = result_;
            if ( [ items_ count ] == 0 )
            {
                did_finish_callback_();
                return;
            }
            SCAsyncOp asyncOp_ = [ items_[ 0 ] fieldsReaderForFieldsNames: fields_ ];
            asyncOp_( ^( id result_, NSError* error_ )
            {
                result_fields_ = result_;
                did_finish_callback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    NSLog( @"products_items_: %@", items_ );
    NSLog( @"result_fields_: %@", result_fields_ );
    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ result_fields_ count ] == 0, @"OK" );
}

-(void)testFieldsValuesReaderWrongFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* result_items_ = nil;
    __block NSDictionary* result_fields_ = nil;

    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
    {
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName ];
        apiContext_ = strongContext_;
        
        NSSet* fields_ = [ NSSet setWithObjects: @"WrongField1", @"WrongField2", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: @"/sitecore/content/home"
                                                                        fieldsNames: [ NSSet new ] ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            result_items_ = items_;
            if ( [ result_items_ count ] == 0 )
            {
                did_finish_callback_();
                return;
            }
            SCAsyncOp asyncOp_ = [ result_items_[ 0 ] fieldsValuesReaderForFieldsNames: fields_ ];
            asyncOp_( ^( id result_, NSError* error_ )
            {
                result_fields_ = result_;
                did_finish_callback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( result_items_ != nil, @"OK" );

    GHAssertTrue( result_fields_ != nil, @"OK" );
    GHAssertTrue( [ result_fields_ count ] == 0, @"OK" );
}

-(void)testFieldValueReaderWrongFieldName 
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_   = nil;
    __block SCField* field_ = nil;
    __block NSDictionary* fields_result_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName ];
            apiContext_ = strongContext_;
            
            [ apiContext_ itemReaderForItemPath:  SCHomePath ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                NSSet* fields_ = [ NSSet setWithObject: @"WrongField" ];
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    fields_result_ = result_;
                    didFinishCallback_();
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ == nil, @"OK" );
    GHAssertTrue( [ fields_result_ count ] == 0, @"OK" );
}

@end
