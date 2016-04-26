package com.waterworld.entities.catchup
{
   import com.waterworld.entities.BuildingFoundation;
   import package_10.BaseManager;
   
   public class class_172 extends Object
   {
       
      public function class_172()
      {
         super();
      }
      
      public static function catchUp(param1:BuildingFoundation, param2:int) : Boolean
      {
         var _loc4_:* = false;
         var _loc3_:* = 0;
         if(param1.upgradeEndTime)
         {
            if(param1.var_37 > 0)
            {
               param1.addTimeToUpgradeEndTime(param1.var_37);
               param1.addTimeToUpgradeStartTime(param1.var_37);
            }
            if(param1.hp == param1.hpMax)
            {
               if(param1.isUpgradePaused())
               {
                  BaseManager.getInstance().activityQueue.removeActivity("building" + param1._id);
                  _loc4_ = BaseManager.getInstance().activityQueue.addActivity("building" + param1._id,param1);
                  if(_loc4_)
                  {
                     param1.hasWorker();
                     param1.var_331 = true;
                     param1.unpauseUpgrade();
                  }
               }
               if(param1.var_793 || !param1._buildingProps.var_308)
               {
                  _loc3_ = param1.upgradeEndTime + param1.upgradePauseDelta - param1.upgradeSpeedUpTime - param1.var_119 - param2;
                  if(_loc3_ <= 0)
                  {
                     param1.upgraded();
                  }
               }
            }
            return true;
         }
         return false;
      }
   }
}
