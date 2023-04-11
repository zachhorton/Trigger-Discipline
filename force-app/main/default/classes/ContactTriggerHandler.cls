public without sharing class ContactTriggerHandler extends TriggerX {
    
    // Method executed to perform AFTER_INSERT operations, overwrite if applicable
	public override void onAfterInsert(){
        MakeFollowUpTask((Contact[]) records);
	}

/*
	// Method executed to perform BEFORE_INSERT operations, overwrite if applicable
	public override void onBeforeInsert(){
		//MatchPublicGroupToChatter((CollaborationGroupMember[])records);
	}

	// Method executed to perform BEFORE_UPDATE operations, overwrite if applicable
	public override void onBeforeUpdate(Map<Id,sObject> triggerOldMap){
	}
    
	// Method executed to perform BEFORE_DELETE operations, overwrite if applicable
	public override void onBeforeDelete(){
	}

	// Method executed to perform AFTER_UPDATE operations, overwrite if applicable
	public override void onAfterUpdate(Map<Id,sObject> triggerOldMap){
	}

	// Method executed to perform AFTER_DELETE operations, overwrite if applicable
	public override void onAfterDelete(){
	}

	// Method executed to perform AFTER_UNDELETE operations, overwrite if applicable
	public override void onAfterUndelete(){
	}
*/
    


    private static void MakeFollowUpTask(Contact[] records) {
        // Check if user is admin...skip
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        if (adminProfile.Id == UserInfo.getProfileId()) return;

        List<Task> tasks = new List<Task>();
        Date threeDaysOut = System.today().addDays(3);
        for (Contact cont : records) {
            Task tsk = new Task(
                ActivityDate = threeDaysOut,
                OwnerId = cont.OwnerId,
                Status = 'Not Started',
                Subject = 'New Contact Follow Up',
                WhoId = cont.Id
            );
            tasks.add(tsk);
        }
        insert tasks;
    }
}