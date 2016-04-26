package com.waterworld.managers.store.storeitem
{
   import package_151.TokenVO;
   import com.waterworld.entities.BuildingFoundation;
   import com.waterworld.core.GLOBAL;
   import package_11.class_22;
   import package_11.StoreEvent;
   import package_59.AbstractLogEvent;
   import com.waterworld.managers.currency.CurrencyDataManager;
   
   public class TokenUseStoreItem extends CommonSpeedupStoreItem
   {
       
      private var var_891:TokenVO;
      
      public function TokenUseStoreItem(param1:TokenVO, param2:String)
      {
         var_891 = param1;
         super(param2);
      }
      
      public function initToUse(param1:BuildingFoundation = null, param2:Array = null) : void
      {
         var_1806 = param2;
         if(param1 == null)
         {
            var param1:BuildingFoundation = GLOBAL.selectedBuilding;
         }
         var_18 = param1._id;
         _time = var_891.time * 60;
         var _loc3_:Boolean = isBuildingRepairingFleet(param1);
         setModeFromFoundation(param1,_loc3_);
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         class_22.instance.dispatchEvent(new StoreEvent("purchasecomplete"));
      }
      
      override public function apply(param1:Object) : String
      {
         return this.doApply();
      }
      
      override protected function mutateLogData(param1:AbstractLogEvent) : AbstractLogEvent
      {
         param1.addNameValuePair("gold",0);
         param1.addNameValuePair("oil",0);
         param1.addNameValuePair("energy",0);
         param1.addNameValuePair("metal",0);
         param1.addNameValuePair("zynth",0);
         param1.addNameValuePair("uranium",0);
         param1.addNameValuePair("paid_time",0);
         return CurrencyDataManager.getInstance().addTokenInfoToLog(var_891,param1);
      }
   }
}
