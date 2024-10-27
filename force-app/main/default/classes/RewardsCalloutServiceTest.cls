@isTest
public class RewardsCalloutServiceTest {
    
    @testsetup
    static void setup(){
                User usr1 = new User(
            FirstName = 'Test',
            LastName = 'User 1',
            Email = 'testuser1@example.com',
            Username = 'testuser114289642711@example.com',
            Alias = 'tuser1',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert usr1;

        User usr2 = new User(
            FirstName = 'Test',
            LastName = 'User 2',
            Email = 'testuser2@example.com',
            Username = 'testuser114289642712@example.com',
            Alias = 'tuser2',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert usr2;

        // Create test Wellness_Journey__c records
        List<Wellness_Journey__c> journeys = new List<Wellness_Journey__c>();
        for (Integer i = 0; i < 13; i++) {
            journeys.add(new Wellness_Journey__c(
                Name = 'Journey ' + i,
                OwnerId = usr1.Id,
                Status__c = 'Complete',
                Completion_Date__c = Date.today().addDays(-90)
            ));
        }

        for (Integer i = 0; i < 5; i++) {
            journeys.add(new Wellness_Journey__c(
                Name = 'Journey ' + (13 + i),
                OwnerId = usr2.Id,
                Status__c = 'Complete',
                Completion_Date__c = Date.today().addDays(-90)
            ));
        }

        insert journeys;
    }
    
    @isTest
    static void testSubmitUsersForRewardCallout_Success() {
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock());
        Integer statusCode;
        Date startDate = Date.today().addMonths(-1);
        Date endDate = Date.today();
        List<Wellness_Journey__c> journeys = [SELECT Id, Name, OwnerId, Owner.Name, Owner.Email, Owner.Username 
                                              FROM Wellness_Journey__c 
                                              WHERE Status__c = 'Complete' 
                                              AND Completion_Date__c >= :startDate 
                                              AND Completion_Date__c <= :endDate 
                                              ORDER BY OwnerId, Completion_Date__c];
        
        Test.startTest();
        statusCode = RewardsCalloutService.submitUsersForRewardCallout(JSON.serialize(journeys));
        Test.stopTest();
        Assert.areEqual(200, statusCode, 'Expected 200 status code');
    }
    
    @isTest
    static void testSubmitUsersForRewardCallout_Exception() {
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock());
        Integer statusCode;
        Date startDate = Date.today().addMonths(-1);
        Date endDate = Date.today();
        List<Wellness_Journey__c> journeys = [SELECT Id, Name, OwnerId, Owner.Name, Owner.Email, Owner.Username 
                                              FROM Wellness_Journey__c 
                                              WHERE Status__c = 'Complete' 
                                              AND Completion_Date__c >= :startDate 
                                              AND Completion_Date__c <= :endDate 
                                              ORDER BY OwnerId, Completion_Date__c];
        
        try{
            statusCode = RewardsCalloutService.submitUsersForRewardCallout(JSON.serialize(journeys));
        }catch(Exception ex){
            
        }
        Assert.areEqual(500, statusCode, 'Expected 500 status code');
    }
    
    @isTest
    static void testWellnessJourneyBatch() {
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock());
        Integer statusCode;
        
        Test.startTest();
        WellnessJourneyRewardsBatch batch = new WellnessJourneyRewardsBatch();        
        Database.executebatch(batch);
        Test.stopTest();
    }
    
}