//
//  NKARCMacros.h
//

//  http://raptureinvenice.com/arc-support-without-branches/
//  http://iosdeveloperzone.com/2013/05/24/snippet-macros-for-arc-agnostic-code/


#if !__has_feature(objc_arc)
#define NK_PROP_RETAIN retain
#define NK_RETAIN(x) ([(x) retain])
#define NK_RELEASE(x) ([(x) release])
#define NK_AUTORELEASE(x) ([(x) autorelease])
#define NK_BLOCK_COPY(x) (Block_copy(x))
#define NK_BLOCK_RELEASE(x) (Block_release(x))
#define NK_SUPER_DEALLOC() ([super dealloc])
#define NK_BRIDGE_CAST(_type, _identifier) ((__bridge _type)(_identifier))
#define NK_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#define NK_AUTORELEASE_POOL_END() [pool release];
#else
#define NK_PROP_RETAIN strong
#define NK_RETAIN(x) (x)
#define NK_RELEASE(x)
#define NK_AUTORELEASE(x) (x)
#define NK_BLOCK_COPY(x) (x)
#define NK_BLOCK_RELEASE(x)
#define NK_SUPER_DEALLOC()
#define NK_BRIDGE_CAST(_type, _identifier) ((_type)(_identifier))
#define NK_AUTORELEASE_POOL_START() @autoreleasepool {
#define NK_AUTORELEASE_POOL_END() }
#endif
