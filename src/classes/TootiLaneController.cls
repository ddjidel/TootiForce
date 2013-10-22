global class TootiLaneController {
    
    public String lanename{get; set;}
    public static String lng;
    public static String lat;
    
    public List<SelectOption> getLaneNames(){
        
        List<SelectOption> options = new List<SelectOption>();
        List<Lane__c> lanes = [select Id, Name, Lane_Id__c from Lane__c ];
        
        options.add(new SelectOption('--None--','--None--'));
        
        for (Integer j = 0; j < lanes.size(); j++) {
        
            options.add(new SelectOption(lanes[j].Name, lanes[j].Name));
        }
        
        return options;
    }
    
    public void setLaneNames(String laneName){
    	
    	this.lanename = laneName;
    }
    
    static String retValue;
    
    @RemoteAction    
    global static String PostFeedItem(String feedItem) {
        
        User user = [select Email, Password__c from User where LastName = 'Djidel'];
        
        String email = user.Email;
        String password = user.Password__c;

        WebServiceUtil.Login login = new WebServiceUtil.Login();
        login = WebServiceUtil.Login(email, password);
        
        // String postText = WebServiceUtil.PostText(login.UserToken, email, login.DefaultLaneId, feedItem);
        // String postDoc = WebServiceUtil.PostDoc(login.UserToken, email, login.DefaultLaneId);
        
        return retValue;
    }
    
    @RemoteAction
    global static void SetCoordinates(String latitude, String longitude){
    	
    	lat = latitude;
    	lng = longitude;
    }
    
	public FeedItem feeditem{
    	
    	get {
      		if (feeditem == null)
        	feeditem = new FeedItem();
      		return feeditem;
    	}
    	set;
  	}
     
	public PageReference share() {
		
	    feeditem.Type = 'ContentPost';
	    feeditem.ParentId = UserInfo.getUserId();
	    User user = [select Email, Password__c from User where LastName = 'Djidel'];
	   	String email = user.Email;
	    String password = user.Password__c;
	    
	    WebServiceUtil.Login login = new WebServiceUtil.Login();
	 
	    try {
	    
	    	Blob fileBody = feedItem.ContentData;
	    	String fileName = feeditem.ContentFileName;
	    	String feedItemText = feedItem.Body;
	    	String fileType = '.' + fileName.substringAfterLast('.');
	    	
	    	MIME_Type__c mimeType = [select Name from MIME_Type__c where Extension__c = :fileType];
	    	Lane__c lane = [select Lane_Id__c from Lane__c where Name = :laneName];
	    	
	        login = WebServiceUtil.Login(email, password);
	        
	        // String postText = WebServiceUtil.PostText(login.UserToken, email, lane.Lane_Id__c, feedItemText);
	        insert feeditem;
	        WebServiceUtil.PostDoc(login.UserToken, email, lane.Lane_Id__c, feedItemText, fileName, fileBody, fileType, mimeType.Name);	      
	      	
	    } 
	    catch (DMLException e) {
	      
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
			return null;
	    } 
	    finally {
	    	
			feeditem = new FeedItem();
	    }
	 
		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
	    return null;
	}
}