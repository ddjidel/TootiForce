trigger PostToTootiLane on FeedItem (after insert) {
	
	String parentId, feedItemBody;
	static final String TOOTILANE_API = 'https://apis.tootilife.com';
	static final String LOGIN_URL = '/api/AuthenticationApi/CheckCredentials';
    static final String CONTENT_TYPE = 'Content-Type';
    static final String APPLICATION_JSON = 'application/json';
    static final String DEVICE_TYPE = 'deviceType';
    static final String DEVICE = 'SalesForceChatter';
    static final String POST = 'POST';    
	
	for(FeedItem thisFeedItem : Trigger.new) {
		
		parentId = thisFeedItem.ParentId;
		feedItemBody = thisFeedItem.Body;
	}
	
	system.debug('parentId: ' + parentId);
	
	String endpoint = TOOTILANE_API + LOGIN_URL;
	
	try {
		
		Lane__c theLane = [select Sync_Status__c, Lane_Id__c from Lane__c where Group_Id__c = :parentId];		
		User user = [select Email, Password__c from User where LastName = 'Djidel'];

        if(theLane.Sync_Status__c){
        	
	       	String email = user.Email;
	        String password = user.Password__c;
        }
	}
	catch(Exception e){
		
	}
}