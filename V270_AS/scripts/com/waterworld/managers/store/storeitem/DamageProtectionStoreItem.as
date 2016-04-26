package com.waterworld.managers.store.storeitem
{
   import com.waterworld.managers.store.STORE;
   import com.waterworld.core.GlobalProperties;
   
   public class DamageProtectionStoreItem extends StoreItem
   {
       
      public function DamageProtectionStoreItem(param1:String)
      {
         super(param1);
         var _loc2_:Object = STORE.var_104[param1];
         var_87.Set(_loc2_.cost[0]);
      }
      
      public function initToBuy() : void
      {
         var _loc1_:* = STORE.var_104[this.var_57];
         setFBCWindowProps(_loc1_.title,_loc1_.description,cost,"StorePopup");
         var_833 = true;
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:Object = super.getAnalyticsData();
         _loc1_.action = "damageprotection";
         return _loc1_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         return this.doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc3_:* = null;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         var _loc2_:Object = STORE.var_104[var_57];
         var _loc4_:Object = {
            "q":1,
            "e":GlobalProperties.gameTime + _loc2_.duration
         };
         STORE.var_146[storeCode] = _loc4_;
         return _loc3_;
      }
   }
}
