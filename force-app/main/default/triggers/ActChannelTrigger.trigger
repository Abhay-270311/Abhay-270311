trigger ActChannelTrigger on Account_Channel__e (after insert) {
    system.debug('Inside Act Channel Event Trigger');
    Messaging.CustomNotification notification = new Messaging.CustomNotification();
    notification.setTitle('Apex Custom Notification');
    notification.setBody('These notifications are coming from inside Channel Event Trigger.');
    notification.setNotificationTypeId('0ML5g0000004CpsGAE');
    notification.setTargetId('a045g000002HVTyAAO');
    notification.send(new Set<String> { '0055g000006hIpD'});
    
}