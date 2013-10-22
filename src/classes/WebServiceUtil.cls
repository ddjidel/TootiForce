public class WebServiceUtil {

    static final String CONTENT_TYPE = 'Content-Type';
    static final String APPLICATION_JSON = 'application/json';
    static final String DEVICE_TYPE = 'deviceType';
    static final String DEVICE = 'SalesForceChatter';
    static final String POST = 'POST';
    static final String TOOTILANE_API = 'https://apis.tootilife.com';
    static final String LOGIN_URL = '/api/AuthenticationApi/CheckCredentials';
    static final String LIST_LANES_URL = '/api/LaneApi/LoadAllTootiLanes';
    static final String SAVE_TOOTIT_DOC_URL = '/api/DiaryTweetLineApi/SaveTootiDoc/';
    static final String SAVE_TOOTIT_TEXT_URL = '/api/DiaryTweetLineApi/SaveTootiText/';
    static final String NEW_LANE_URL = '/api/LaneApi/CreateNewLane';
    static final String ONE_CR = '\r\n';
    static final String TWO_CR = '\r\n\r\n';
    
    static String retValue;
    
    public class Login {
        
        public Integer LoginErrorCode;
        public String UserToken;
        public String OfferingCode;
        public Boolean IsBusiness;
        public String DefaultLaneId;
        public String DefaultLaneName;
        public String DefaultLaneEmail;
        public Boolean DefaultLaneIsMain;
        public String BingMapKey;
        public String NuanceAppId;
        public String NuanceAppKey;
        public String NuanceServerName;
        public Integer NuanceServerPort;
        public String NuanceUrlFragments;
        public String TranscriptionAuthorizationCode;
        public Integer MaximumDocumentSize;
        public Integer MaximumPictureSize;
        public Integer MaximumVideoSize;
        public Integer MaxAudioRecordingLength;
        public Integer MaxVideoRecordingLength;
        public Integer MaxAudioTranscriptionLength;
        public String NuanceIphoneAppKey; 
    }
    
    public class Lane {
        
        public String Id;
        public String Name;
        public String Description;
        public String OwnerEmail;
        public Boolean IsBusiness;
        public Boolean IsMain;
        public Boolean IsOwner;
        public Date CreationDate;
        public String GroupKey;
        public String Email;
        public Boolean IsEmailCodeActive;
        public String EmailAuthorizationCode;
    }

    public class NewLane {
    	
    	public String Id;
		public String Name;
		public String Description;
		public Boolean IsBusiness;
		public Long CreationDate;
		public Boolean IsMain;
		public String Email;
		public Boolean IsEmailCodeActive;
		public String EmailAuthorizationCode;
		public Integer Status;
		public Boolean IsOwner;
		public String OwnerEmail;
		public String GroupKey;
		public Boolean IsUserMailNotificationEnabled;
    }

    public static Login Login(String email, String password) {
 
        String endpoint = TOOTILANE_API + LOGIN_URL;
    
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        req.setHeader(CONTENT_TYPE, APPLICATION_JSON);
        req.setHeader(DEVICE_TYPE, DEVICE);
        req.setMethod(POST);
        req.setEndpoint(endpoint);
        req.setBody('{"email":"' + email + '", "password":"' + password + '"}');
        
        Login l = new Login();
        
        try {
            
            res = http.send(req);
            l = (Login)JSON.deserializeStrict(res.getBody(), Login.class);
            return l;
        } 
        catch(System.CalloutException e) {
            
            retValue = res.toString();
        }
        
        return l;
    }
    
    public static String GetLanes(String userToken, String email, String laneId){
        
        String status = '1';
        String query;
        String endpoint = TOOTILANE_API + LIST_LANES_URL;
        String body = '{"status":"' + status + '", "query":"' + query + '"}';
 
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        req.setHeader(CONTENT_TYPE, APPLICATION_JSON);
        req.setHeader('userToken', userToken);
        req.setHeader('email', email);
        req.setHeader(DEVICE_TYPE, DEVICE);
        req.setHeader('laneId', laneId);
        req.setMethod(POST);
        req.setEndpoint(endpoint);
        req.setBody(body);
        
        Lane l = new Lane();
        
        try {
            
            res = http.send(req);
        } 
        catch(System.CalloutException e) {
            
            retValue = res.toString();
        }
        
        return res.getBody();
    }
    
    public static NewLane CreateLane(String userToken, String email, String name, String description){
        
    	String endpoint = TOOTILANE_API + NEW_LANE_URL;
    	
    	if(description == null)
    		description = '';

        JSONGenerator jsonBody = JSON.createGenerator(true);
        jsonBody.writeStartObject();
        jsonBody.writeStringField('name', name);
        jsonBody.writeStringField('description', description);
        jsonBody.writeBooleanField('isCodeActive', false);
        jsonBody.writeStringField('code', '');
        String body = jsonBody.getAsString();
                
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        req.setHeader(CONTENT_TYPE, APPLICATION_JSON);
        req.setHeader('userToken', userToken);
        req.setHeader('email', email);
        req.setHeader(DEVICE_TYPE, DEVICE);
        req.setMethod(POST);
        req.setEndpoint(endpoint);
        req.setBody(body);
        
        NewLane nl = new NewLane();

        try {
            
            res = http.send(req);
            nl = (NewLane)JSON.deserializeStrict(res.getBody(), NewLane.class);
            return nl;
        } 
        catch(System.CalloutException e) {
            
            retValue = res.toString();
        }
                             
        return nl;
    }    
    
    @future (callout=true)
    public static void PostText(String userToken, String email, String laneId, String text){

        Double longitude = 2.292837;
        Double latitude = 48.864358;

        String tweetDate = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm:ss.SSS\'Z\'');
        Boolean isFavorite = false;
        Integer rating = 0;
        String keywords = 'Salesforce';
        String thumbnailColor = '#1CC9E1';
        String cultureName = 'en-US';
        Integer tweetType = 2;
                
        String endpoint = TOOTILANE_API + SAVE_TOOTIT_TEXT_URL;
        
        JSONGenerator jsonBody = JSON.createGenerator(true);
        jsonBody.writeStartObject();
        jsonBody.writeStringField('text', text);
        jsonBody.writeNumberField('longitude', longitude);
        jsonBody.writeNumberField('latitude', latitude);
        jsonBody.writeStringField('tweetDate', tweetDate);
        jsonBody.writeBooleanField('isFavorite', isFavorite);
        jsonBody.writeNumberField('rating', rating);
        jsonBody.writeStringField('keywords', keywords);
        jsonBody.writeStringField('thumbnailColor', thumbnailColor);
        jsonBody.writeStringField('cultureName', cultureName);
        jsonBody.writeNumberField('tweetType', tweetType);
        jsonBody.writeEndObject();
        String body = jsonBody.getAsString();

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        req.setHeader(CONTENT_TYPE, APPLICATION_JSON);
        req.setHeader('userToken', userToken);
        req.setHeader('email', email);
        req.setHeader(DEVICE_TYPE, DEVICE);
        req.setHeader('laneId', laneId);
        req.setMethod(POST);
        req.setEndpoint(endpoint);
        req.setBody(body);
        
        try {
            
            res = http.send(req);
        } 
        catch(System.CalloutException e) {
            
            retValue = res.toString();
        }
    }
    
    @future (callout = true)
    public static void PostDoc(String userToken, String email, String laneId, String feedItemText, String fileName, Blob fileBody, String fileType, String mimeType){

        String endpoint = TOOTILANE_API + SAVE_TOOTIT_DOC_URL;
        String boundary = String.valueOf(DateTime.now().getTime());
        String header = '------------' + boundary + ONE_CR;
        String tweetDate = '"' + DateTime.now().format('yyyy-MM-dd\'T\'hh:mm:ss.SSS\'Z\'')  + '"';
        String localParentFolder = DateTime.now().format('ddMMyyyy');
    
        header += 'Content-Disposition: form-data; name="cultureName"\r\n\r\n';   
        // header += UserInfo.getLocale() + ONE_CR;
        header += 'en-US' + ONE_CR;
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="email"\r\n\r\n';
        header += email + ONE_CR;
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="uniqueFileName"\r\n\r\n';
        header += filename + ONE_CR;
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="thumbnailUniqueFileName"\r\n\r\n';
        header += '' + ONE_CR;
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="localParentFolder"\r\n\r\n';
        header += localParentFolder + ONE_CR;                        
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="fileContentType"\r\n\r\n';
        header += mimeType + ONE_CR;
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="fileType"\r\n\r\n';
        header += fileType + ONE_CR;
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="tootiText"\r\n\r\n';
        header += filename + ONE_CR;
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="isFavorite"\r\n\r\n';
        header += 'false' + ONE_CR;                       
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="rating"\r\n\r\n';
        header += '0' + ONE_CR;
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="keywords"\r\n\r\n';
        header += 'pdf' + ONE_CR;
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="thumbnailColor"\r\n\r\n';
        header += '#0070C0' + ONE_CR;
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="tweetDate"\r\n\r\n';
        header += tweetDate + ONE_CR;                        
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="longitude"\r\n\r\n';
        header += '2.292837' + ONE_CR;
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="latitude"\r\n\r\n';
        header += '48.864358' + ONE_CR;
        header += '------------' + boundary + ONE_CR + 'Content-Disposition: form-data; name="file";filename="' + filename + '"; filename="blob"\r\nContent-Type: application/pdf'; 
        
        String footer = '\r\n\r\n------------' + boundary + '--' + ONE_CR;
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header + '\r\n\r\n'));
        
        while(headerEncoded.endsWith('=')){
          
            header += ' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header + '\r\n\r\n'));
        }
    
        String bodyEncoded = EncodingUtil.base64Encode(fileBody);
        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                
        Blob bodyBlob = null;
        
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length() - 4, bodyEncoded.length());
    
        if(last4Bytes.endsWith('=')){
          
            Blob decoded4Bytes = EncodingUtil.base64Decode(last4Bytes);
            HttpRequest tmp = new HttpRequest();
            tmp.setBodyAsBlob(decoded4Bytes);
            String last4BytesFooter = tmp.getBody() + footer;  
            bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded.substring(0, bodyEncoded.length() - 4) + EncodingUtil.base64Encode(Blob.valueOf(last4BytesFooter)));
        }
        else{
      
            bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded + footerEncoded);
        }
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        req.setHeader('Content-Type', 'multipart/form-data; boundary=' + '----------' + boundary);
        req.setHeader('userToken', userToken);
        req.setHeader('email', email);
        req.setHeader(DEVICE_TYPE, DEVICE);
        req.setHeader('laneId', laneId);
        req.setBodyAsBlob(bodyBlob);
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setHeader('Content-Length',String.valueof(req.getBodyAsBlob().size()));
            
        try {
                
            res = http.send(req);
        } 
        catch(System.CalloutException e) {
                
            retValue = res.toString();
        }                   
    }
}