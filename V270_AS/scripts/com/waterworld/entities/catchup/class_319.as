package com.waterworld.entities.catchup
{
   import com.waterworld.entities.BuildingFoundation;
   
   public class class_319 extends Object
   {
       
      public function class_319()
      {
         super();
      }
      
      public static function catchUp(param1:BuildingFoundation) : Boolean
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc2_:* = NaN;
         if(param1.isRepairing)
         {
            _loc3_ = getHPPerSecond(param1);
            _loc4_ = param1.hpMax - param1.hp;
            _loc2_ = _loc4_ / _loc3_;
            if(param1.var_119 >= _loc2_)
            {
               param1.setHP(param1.hpMax);
               param1.repaired();
               param1.checkFunctional();
               param1.updateFoundation();
               param1.var_37 = _loc2_;
            }
            else
            {
               param1.setHP(param1.var_119 * _loc3_ + param1.hp);
               param1.var_37 = param1.var_119;
            }
            param1.var_119 = Math.max(0,param1.var_119 - _loc2_);
            param1.accruedNonFunctionalTime = param1.accruedNonFunctionalTime + param1.var_37;
            return true;
         }
         if(param1.hp != param1.hpMax)
         {
            param1.var_37 = param1.var_119;
            param1.accruedNonFunctionalTime = param1.accruedNonFunctionalTime + param1.var_37;
         }
         return false;
      }
      
      private static function getHPPerSecond(param1:BuildingFoundation) : Number
      {
         var _loc2_:* = NaN;
         if(param1.level == 0)
         {
            _loc2_ = param1._buildingProps.costs[0].time / 60;
         }
         else
         {
            _loc2_ = param1._buildingProps.repairTime[param1.level - 1];
         }
         return param1.hpMax / _loc2_;
      }
   }
}
