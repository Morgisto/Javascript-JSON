package com.waterworld.entities.catchup
{
   import com.waterworld.entities.ShipDock;
   import com.waterworld.core.BASE;
   import com.waterworld.datastores.IOShip;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.managers.shipdock.SHIPDOCK;
   import com.waterworld.core.GlobalProperties;
   import package_59.ShipTransactionLogEvent;
   import com.kixeye.utils.json.ActionJSON;
   import package_59.class_223;
   
   public class class_276 extends Object
   {
       
      public function class_276()
      {
         super();
      }
      
      public static function catchUp(param1:ShipDock, param2:int) : Boolean
      {
         var _loc14_:* = undefined;
         var _loc9_:* = null;
         var _loc12_:* = 0;
         var _loc7_:* = 0;
         var _loc13_:* = 0;
         var _loc11_:* = null;
         var _loc3_:* = 0;
         var _loc6_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = NaN;
         var _loc10_:* = 0;
         var _loc8_:* = 0;
         var _loc15_:* = NaN;
         if(param1.var_3184 > 0)
         {
            param1.var_3184 = 0;
         }
         if(param1.var_58)
         {
            if(param1.pendingDefendingFleetUpdate && BASE.guardingFleet.fleetId != -1)
            {
               param1.applyDefendingFleetDamage(param1.pendingDefendingFleetUpdate);
            }
         }
         if(param1.repairEndTime && param1.var_37 > 0)
         {
            param1.addTimeToRepairStartTime(param1.var_37);
            param1.addTimeToRepairEndTime(param1.var_37);
            param1.addTimeToRepairArmorEndTime(param1.var_37);
            param1.addTimeToRepairFleetStartTime(param1.var_37);
         }
         if(param1.isBuildingFunctional())
         {
            if(param1.repairUID == null)
            {
               _loc14_ = param1.getRepairQueue();
               if(_loc14_.length > 0)
               {
                  param1.repairStart(_loc14_[0].uid,param2);
               }
               else if(!param1.isUpgrading && !param1.isRepairing)
               {
                  param1.resetFleetRepairTimes();
               }
            }
            if(param1.repairUID)
            {
               _loc9_ = param1.findShipByID(param1.repairUID);
               if(_loc9_)
               {
                  _loc12_ = param1.repairEndTime - (param2 + param1.repairSpeedUpTime + param1.var_119);
                  if(_loc12_ <= 0)
                  {
                     _loc7_ = modifyRepairSpeedUpTime(param1,_loc9_);
                     _loc13_ = param1.repairEndTime - (param2 + _loc7_);
                     _loc9_.activeArmorPoints = _loc9_.armorPoints;
                     _loc9_.activeDroneAmmo = _loc9_.var_24;
                     _loc11_ = param1.repairUID;
                     param1.repairEnd();
                     _loc3_ = _loc9_.activeArmorPoints - param1.repairStartArmor;
                     GLOBAL.const_10.updateMetric("repair_ship_armor",_loc3_);
                     if(!param1.speedingUp)
                     {
                        SHIPDOCK.repairCompleted(param1,_loc11_);
                     }
                     modifyAndCheckTime(param1,_loc13_,param2);
                  }
                  else if(_loc9_.activeArmorPoints < _loc9_.armorPoints)
                  {
                     _loc6_ = param1.repairArmorEndTime - (param2 + param1.repairSpeedUpTime + param1.var_119);
                     _loc4_ = param1.repairArmorEndTime - param1.repairStartTime;
                     _loc5_ = 1 - _loc6_ / _loc4_;
                     _loc10_ = param1.repairStartArmor + Math.floor(_loc5_ * (_loc9_.armorPoints - param1.repairStartArmor));
                     _loc8_ = Math.min(param1.var_119,_loc4_);
                     _loc9_.activeArmorPoints = _loc10_;
                     modifyAndCheckTime(param1,_loc8_,param2);
                  }
                  else if(_loc9_.var_24 > 0)
                  {
                     _loc15_ = (param1.repairEndTime - (param1.var_119 + GlobalProperties.gameTime + param1.repairSpeedUpTime)) / (param1.repairEndTime - param1.repairArmorEndTime);
                     _loc9_.activeDroneAmmo = param1.repairStartAmmo + ((1 - _loc15_) * (_loc9_.var_24 - param1.repairStartAmmo));
                  }
                  if(!param1.speedingUp)
                  {
                     SHIPDOCK.update(false);
                  }
               }
               else
               {
                  param1.repairCancel(null,false);
               }
               return true;
            }
         }
         return false;
      }
      
      private static function modifyAndCheckTime(param1:ShipDock, param2:int, param3:int) : void
      {
         var param3:int = param3 + param2;
         param1.var_119 = param1.var_119 - param2;
         if(param1.var_119 > 0)
         {
            catchUp(param1,param3);
         }
      }
      
      private static function modifyRepairSpeedUpTime(param1:ShipDock, param2:IOShip) : int
      {
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc3_:* = 0;
         if(param1.repairSpeedUpTime)
         {
            _loc3_ = param1.repairEndTime - GlobalProperties.gameTime;
            if(_loc3_ > 0)
            {
               param1.repairSpeedUpTime = param1.repairSpeedUpTime - _loc3_;
            }
            _loc4_ = _loc3_ > 0?_loc3_:param1.repairSpeedUpTime;
            _loc5_ = new ShipTransactionLogEvent("repair_finished",param2.id.toString(),param2.hullID.toString(),ActionJSON.encodeJSON(param2.analyticExport()),param2.weight.toString(),param2.armorPoints.toString(),param2.fleetId.toString(),param1.repairTimeTotalForCurrentShip.toString(),_loc4_.toString(),"0");
            class_223.sendThroughJavaScript(_loc5_);
         }
         return _loc3_;
      }
   }
}
