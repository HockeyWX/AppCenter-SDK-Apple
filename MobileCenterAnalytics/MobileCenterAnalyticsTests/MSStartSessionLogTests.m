#import "MSStartSessionLog.h"
#import "MSTestFrameworks.h"

@interface MSStartSessionLogTests : XCTestCase

@property(nonatomic) MSStartSessionLog *sut;

@end

@implementation MSStartSessionLogTests

#pragma mark - Houskeeping

- (void)setUp {
  [super setUp];
  self.sut = [MSStartSessionLog new];
}

- (void)tearDown {
  [super tearDown];
}

#pragma mark - Tests

- (void)testSerializingSessionToDictionaryWorks {

  // If
  MSDevice *device = [MSDevice new];
  NSString *typeName = @"start_session";
  NSString *sessionId = @"1234567890";
  long long createTime = (long long)[MSUtility nowInMilliseconds];
  NSNumber *tOffset = @(createTime);

  self.sut.device = device;
  self.sut.toffset = tOffset;
  self.sut.sid = sessionId;

  // When
  NSMutableDictionary *actual = [self.sut serializeToDictionary];

  // Then
  assertThat(actual, notNilValue());
  assertThat(actual[@"type"], equalTo(typeName));
  assertThat(actual[@"device"], notNilValue());
  NSTimeInterval seralizedToffset = [actual[@"toffset"] longLongValue];
  NSTimeInterval actualToffset = [MSUtility nowInMilliseconds] - createTime;
  assertThat(@(seralizedToffset), lessThan(@(actualToffset)));
}

- (void)testNSCodingSerializationAndDeserializationWorks {

  // If
  MSDevice *device = [MSDevice new];
  NSString *typeName = @"start_session";
  NSString *sessionId = @"1234567890";
  NSNumber *tOffset = @(3);

  self.sut.device = device;
  self.sut.toffset = tOffset;
  self.sut.sid = sessionId;

  // When
  NSData *serializedEvent = [NSKeyedArchiver archivedDataWithRootObject:self.sut];
  id actual = [NSKeyedUnarchiver unarchiveObjectWithData:serializedEvent];

  // Then
  assertThat(actual, notNilValue());
  assertThat(actual, instanceOf([MSStartSessionLog class]));

  MSStartSessionLog *actualSession = actual;
  assertThat(actualSession.device, notNilValue());
  assertThat(actualSession.toffset, equalTo(tOffset));
  assertThat(actualSession.type, equalTo(typeName));
  assertThat(actualSession.sid, equalTo(sessionId));
}

@end
