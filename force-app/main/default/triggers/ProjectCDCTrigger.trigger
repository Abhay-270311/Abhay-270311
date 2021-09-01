trigger ProjectCDCTrigger on Project__ChangeEvent (after insert) {
    //Iterate through each event message.
    for (Project__ChangeEvent event : Trigger.New) {
        //Get event header fields
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        
        switch on header.changeType {
            when 'CREATE'{
                //Craete logic
                System.debug('CREATE');
                break;
            }
            when 'UPDATE'{
                //Update logic
                System.debug('UPDATE');
                break;
            }
            when 'DELETE'{
                //Delete logic
                System.debug('DELETE');
                break;
            }
            when 'UNDELETE'{
                //Undelete logic
                System.debug('UNDELETE');
                break;
            }
        }
    }
}