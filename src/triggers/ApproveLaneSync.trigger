trigger ApproveLaneSync on CollaborationGroup (after insert) {

	String groupId;
	
	for(CollaborationGroup thisGroup : Trigger.new){
		
		groupId = thisGroup.Id;
		Lane__c groupLane = new Lane__c(Name = thisGroup.Name, Description__c = thisGroup.Description, Group_Id__c = groupId);
		insert(groupLane);
	}
	
	Lane__c groupLane = [select Id from Lane__c where Group_Id__c = :groupId];
	Approval.Processsubmitrequest processSubmitRequest = new Approval.Processsubmitrequest();
	
	processSubmitRequest.setObjectId(groupLane.Id);
	Approval.ProcessResult result = Approval.process(processSubmitRequest);
}