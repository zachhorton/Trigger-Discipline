/**
 * Copyright (c) 2012-2014, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

public class OpportunitiesTriggerHandler extends fflib_SObjectDomain
{
	public OpportunitiesTriggerHandler(List<Opportunity> sObjectList)
	{
		// Domain classes are initialised with lists to enforce bulkification throughout
		super(sObjectList);
	}
    
	public class Constructor implements fflib_SObjectDomain.IConstructable
	{
		public fflib_SObjectDomain construct(List<SObject> sObjectList)
		{
			return new OpportunitiesTriggerHandler(sObjectList);
		}
	}

	public override void onApplyDefaults()
	{
		// Apply defaults to OpportunityTriggerHandler
		for(Opportunity opportunity : (List<Opportunity>) this.records)
		{
			// opportunity.DiscountType__c = OpportunitySettings__c.getInstance().DiscountType__c;
		}
	}

	public override void onValidate()
	{
		// Validate OpportunityTriggerHandler
		for(Opportunity opp : (List<Opportunity>) this.records)
		{
			if(opp.Type != null && opp.Type.startsWith('Existing') && opp.AccountId == null)
			{
				opp.AccountId.addError( error('You must provide an Account for OpportunityTriggerHandler for existing Customers.', opp, Opportunity.AccountId) );
			}
		}
	}

	public override void onValidate(Map<Id,SObject> existingRecords)
	{
		// Validate changes to OpportunityTriggerHandler
		for (Opportunity opp : (List<Opportunity>) this.records)
		{
			Opportunity existingOpp = (Opportunity) existingRecords.get(opp.Id);
			if (opp.Type != existingOpp.Type)
			{
				opp.Type.addError( error('You cannot change the Opportunity type once it has been created.', opp, Opportunity.Type) );
			}
		}
	}

	public override void onAfterInsert()
	{
		SetFollowUpTask();
	}

	private void SetFollowUpTask()
	{
        List<Task> newTasks = new List<Task>();
        for (Opportunity opp : (List<Opportunity>) this.records) {
            Task t = new Task(
                Subject = 'New Opp Follow-up',
                WhatId = opp.Id,
                ActivityDate = System.today().addDays(3),
                Status = 'Pending'
            );
            newTasks.add(t);
        }

		insert newTasks;
	}

}