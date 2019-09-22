public class FridgeLogTriggerHandler {
    public static void handleEvent(List<Fridge_Log__e> events) {
        //簡便のため、すべてのロジックをハンドラクラス内に記載しています。
        
        Map<String, Set<FridgeLogEvent>> employeeNameToEventsMap = new Map<String, Set<FridgeLogEvent>>();
        for (Fridge_Log__e event : events) {
            FridgeLogEvent fle = new FridgeLogEvent(event.ReplayId, event.badgeId__c, event.fridgeId__c);
            if (employeeNameToEventsMap.containsKey(event.employeeName__c)) {
                employeeNameToEventsMap.get(event.employeeName__c).add(fle);
                } else {
                employeeNameToEventsMap.put(event.employeeName__c, new Set<FridgeLogEvent>{ fle });
            }
        }
        List<Contact> contacts = [
            SELECT Name
            FROM Contact
            WHERE Name IN :employeeNameToEventsMap.keySet()
        ];
        List<Fridge_History__c> fridgeHistoryRecords =  new List<Fridge_History__c>();
        for (Contact contact : contacts) {
            for (FridgeLogEvent fle : employeeNameToEventsMap.get(contact.Name)) {
                Fridge_History__c fh = new Fridge_History__c(
                    Contact__c = contact.Id,
                    BadgeId__c = fle.badgeId,
                    FridgeId__c = fle.fridgeId
                );
                fridgeHistoryRecords.add(fh);
            }
        }

        if (!fridgeHistoryRecords.isEmpty()) {
            insert fridgeHistoryRecords;
        }
    }

    public class FridgeLogEvent {
        public String replayId;
        public String badgeId;
        public String fridgeId;
        public FridgeLogEvent(String replayId, String badgeId, String fridgeId) {
            this.replayId = replayId;
            this.badgeId = badgeId;
            this.fridgeId = fridgeId;
        }

        public Boolean equals(Object obj) {
            if (obj instanceof FridgeLogEvent) {
                FridgeLogEvent e = (FridgeLogEvent)obj;
                return (this.replayId.equals(e.replayId));
            }
            return false;
        }

        public Integer hashCode() {
            return 31 + Integer.valueOf(replayId);
        }
    }
}
