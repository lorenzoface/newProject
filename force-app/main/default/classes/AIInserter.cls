public class AIInserter {
	public static void insertPrediction(String objId,String objectName,String fieldName)
    {
        List<MLPredictionDefinition> pds = [select Id from MLPredictionDefinition];
        MLPredictionDefinition pd = pds.get(0);
        AIRecordInsight ri = new AIRecordInsight(MlPredictionDefinitionId=pd.Id,Confidence=0.2,RunGUID='93554231-ba4a-43fd-8a11-458330e76db9',RunStartTime=DateTime.now(),TargetField=objectName+'.'+fieldName,TargetId=objId,TargetSObjectType=objectName,Type='SingleValue');    
    	insert ri;
        // useless comment
        // another pointless line of text
        
        Double dblRand = Math.random()*100.0;
        Integer rand = dblRand.intValue();
        String strRand = String.valueOf(rand);
        
        AIInsightValue iv = new AIInsightValue(AiRecordInsightId=ri.Id,Confidence=0.2,Field=objectName+'.'+fieldName,Value=strRand,ValueType='Number');
        insert iv;
    }
    
    public static void insertPredictions(List<sObject> objects,String objectName,String fieldName) 
    {
        List<MLPredictionDefinition> pds = [select Id from MLPredictionDefinition];
        MLPredictionDefinition pd = pds.get(0);
        List<AIRecordInsight> ris = new List<AIRecordInsight>();
        List<AIInsightValue> ivs = new List<AIInsightValue>();
        Map<String,AIRecordInsight> riMap = new Map<String,AIRecordInsight>();
        
        for (sObject sobj:objects) {
            String objId = sobj.Id;
            AIRecordInsight ri = new AIRecordInsight(MlPredictionDefinitionId=pd.Id,Confidence=0.2,RunGUID='93554231-ba4a-43fd-8a11-458330e76db9',RunStartTime=DateTime.now(),TargetField=objectName+'.'+fieldName,TargetId=objId,TargetSObjectType=objectName,Type='SingleValue');    
            ris.add(ri);
            riMap.put(objId, ri);
        }
        
        insert ris;
        
        for (sObject sobj:objects) {
            String objId = sobj.Id;
            AIRecordInsight ri = riMap.get(objId); 
            
            Double dblRand = Math.random()*100.0;
            Integer rand = dblRand.intValue();
            String strRand = String.valueOf(rand);
        
            AIInsightValue iv = new AIInsightValue(AiRecordInsightId=ri.Id,Confidence=0.2,Field=objectName+'.'+fieldName,Value=strRand,ValueType='Number');
            ivs.add(iv);
        }
        
        insert ivs;
    }
    
    public static Boolean hasPredictionDefinition()
    {
        List<MLPredictionDefinition> defs = [SELECT Id from MLPredictionDefinition];
        return !defs.isEmpty();
    }
    
    @future
    public static void insertPredictionsOnContacts()
    {
        List<Contact> newNonMembers = [SELECT Id FROM Contact WHERE VeloStars_Member__c=false AND First_Purchase__c>=2018-01-01];
        AIInserter.insertPredictions(newNonMembers, 'Contact', 'Membership_Likelihood__c');
    }
}