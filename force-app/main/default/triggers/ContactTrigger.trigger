trigger ContactTrigger on Contact (after insert) {
    for(Contact ct : Trigger.new) {
        if (ct.AccountId != null) {
            Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
            approvalRequest.setComments('Create contact approval');
            approvalRequest.setObjectId(ct.Id);
            List<User> listUser = [Select ID from User where profile.name = 'System Administrator' Limit 1];
            List<ID> listId = new List<ID>();
            for (User us: listUser) {
                listId.add(us.ID);
            }
            
            approvalRequest.setNextApproverIds(listId);
            Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
            System.debug('contact submitted for approval successfully: ' + approvalResult.isSuccess());
        }
    }
}