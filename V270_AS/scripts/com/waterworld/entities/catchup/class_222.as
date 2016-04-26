package com.waterworld.entities.catchup
{
   import com.waterworld.entities.BuildingFoundation;
   import package_10.BaseManager;
   
   public class class_222 extends Object
   {
       
      public function class_222()
      {
         super();
      }
      
      public static function catchUp(param1:BuildingFoundation, param2:int) : Boolean
      {
         var _loc4_:* = false;
         var _loc3_:* = 0;
         if(param1.buildingEndTime)
         {
            if(param1.var_37 > 0)
            {
               param1.addTimeToBuildingEndTime(param1.var_37);
               param1.addTimeToBuildingStartTime(param1.var_37);
            }
            if(param1.hp == param1.hpMax)
            {
               if(param1.isConstructionPaused())
               {
                  BaseManager.getInstance().activityQueue.removeActivity("building" + param1._id);
                  _loc4_ = BaseManager.getInstance().activityQueue.addActivity("building" + param1._id,param1);
                  if(_loc4_)
                  {
                     param1.unpauseConstruction();
                     param1.hasWorker();
                     param1.var_331 = true;
                  }
               }
               if(param1.var_793 || !param1._buildingProps.var_308)
               {
                  _loc3_ = param1.buildingEndTime + param1.buildPauseDelta - param1.buildingSpeedUpTime - param1.var_119 - param2;
                  if(_loc3_ <= 0)
                  {
                     param1.constructed();
                  }
               }
               param1.var_58 = 0 == param1.buildingEndTime;
            }
            return true;
         }
         return false;
      }
   }
}
