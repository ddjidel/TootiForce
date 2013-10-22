trigger CreateLane on Lane__c (after update) {

	Boolean oldSyncStatus, newSyncStatus;
	String laneId, laneName, laneDescription;

	for(Lane__c thisLane : Trigger.old){
		
		oldSyncStatus = thisLane.Sync_Status__c;
	}
		
	for(Lane__c thisLane : Trigger.new){
		
		newSyncStatus = thisLane.Sync_Status__c;
		laneId = thisLane.Id;
		laneName = thisLane.Name;
		laneDescription = thisLane.Description__c;
	}
	
	if(newSyncStatus != oldSyncStatus && newSyncStatus){
		
		LaneUtil.Create(laneId, laneName, laneDescription);
	}
}