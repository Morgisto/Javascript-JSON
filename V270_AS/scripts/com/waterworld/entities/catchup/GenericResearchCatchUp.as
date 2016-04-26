package com.waterworld.entities.catchup
{
   import com.kixeye.logging.KXLogger;
   import com.waterworld.entities.BuildingGenericResearch;
   import com.waterworld.core.GLOBAL;
   import package_97.RESEARCH;
   import package_155.class_290;
   import package_149.class_269;
   import com.waterworld.core.BASE;
   import com.kixeye.logging.class_72;
   
   public class GenericResearchCatchUp extends Object
   {
      
      private static var _log:KXLogger = class_72.getLoggerForClass(GenericResearchCatchUp);
      
      {
         _log = class_72.getLoggerForClass(GenericResearchCatchUp);
      }
      
      public function GenericResearchCatchUp()
      {
         super();
      }
      
      public static function catchUp(param1:BuildingGenericResearch, param2:int) : Boolean
      {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         if(param1.researchID > 0)
         {
            if(param1.var_37 > 0)
            {
               param1.addTimeToResearchEndTime(param1.var_37);
               param1.addTimeToResearchStartTime(param1.var_37);
            }
            if(param1.isBuildingFunctional() && GLOBAL.baseMode == "build")
            {
               _loc4_ = param1.researchEndTime - (param2 + param1.researchSpeedUpTime + param1.var_119);
               if(_loc4_ <= 0)
               {
                  param1.researchCompleted();
               }
               else if(RESEARCH.isResearched(param1.researchID) || class_290.isComplete(param1.researchID))
               {
                  _loc3_ = "Researching previously researched tech. Research id: " + param1.researchID;
                  _log.logRemote("ERROR.GenericResearchCatchUp.catchUp",_loc3_);
                  class_269.fail("Researching previously researched tech. Research id: " + param1.researchID);
                  param1.researchEnd();
                  GLOBAL.debugRequestToSave.push("GenericResearchCatchUp.catchUp");
                  BASE.save(0,true);
               }
            }
            return true;
         }
         return false;
      }
   }
}
