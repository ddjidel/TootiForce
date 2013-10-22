public class LaneUtil {
    
    @future (callout = true)
    public static void Create(String laneId, String laneName, String laneDescription){
        
        User user = [select Email, Password__c from User where LastName = 'Djidel'];
        Lane__c theLane = [select Lane_Id__c from Lane__c where Id = :laneId];
        
        String email = user.Email;
        String password = user.Password__c;
    
        WebServiceUtil.Login login = new WebServiceUtil.Login();
        login = WebServiceUtil.Login(email, password);
        
        WebServiceUtil.NewLane nl = new WebServiceUtil.NewLane();
        nl = WebServiceUtil.CreateLane(login.UserToken, email, laneName, laneDescription);
        
        theLane.Lane_Id__c = nl.Id;
        update(theLane);
    }
    
    public static void GetList(){
        
        User user = [select Email, Password__c from User where LastName = 'Djidel'];
        
        String email = user.Email;
        String password = user.Password__c;
    
        WebServiceUtil.Login login = new WebServiceUtil.Login();
        login = WebServiceUtil.Login(email, password);
        
        WebServiceUtil.Lane lane = new WebServiceUtil.Lane();
        
        String getLanes = WebServiceUtil.GetLanes(login.UserToken, email, login.DefaultLaneId);
    }
    
    @future (callout = true)
    public static void Post(String laneId){
    	
    	User user = [select Email, Password__c from User where LastName = 'Djidel'];
        Lane__c theLane = [select Lane_Id__c from Lane__c where Id = :laneId];
        
        String email = user.Email;
        String password = user.Password__c;
    
        WebServiceUtil.Login login = new WebServiceUtil.Login();
        login = WebServiceUtil.Login(email, password);
        
        // WebServiceUtil.PostDoc(login.UserToken, email, theLane.Lane_Id__c, feedItemText, fileName, fileBody, fileType, mimeType);
    }
}