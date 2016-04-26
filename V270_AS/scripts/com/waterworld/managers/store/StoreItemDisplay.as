package com.waterworld.managers.store
{
   import com.waterworld.ui.class_242;
   import flash.display.DisplayObjectContainer;
   import com.waterworld.utils.movieclip.class_277;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import com.waterworld.display.ButtonManager;
   import com.waterworld.resources.BPResourceManager;
   
   public class StoreItemDisplay extends class_242
   {
      
      protected static const const_2992:Number = 1;
      
      protected static const const_649:Number = 0.3;
       
      protected var var_1237:String;
      
      protected var var_659:class_672;
      
      protected var var_3514:Function;
      
      protected var _x:int;
      
      protected var _y:int;
      
      public function StoreItemDisplay(param1:String = "AssetStoreItem")
      {
         super();
         load(param1);
      }
      
      override protected function loaded() : void
      {
         updateDisplay();
      }
      
      public function attachTo(param1:DisplayObjectContainer) : void
      {
         param1.addChild(_asset);
      }
      
      public function setStoreItem(param1:String, param2:class_672, param3:int, param4:int, param5:Function = null) : void
      {
         var_659 = param2;
         setCommonItem(param1,param3,param4,param5);
      }
      
      protected function setCommonItem(param1:String, param2:int, param3:int, param4:Function = null) : void
      {
         var_1237 = param1;
         _x = param2;
         _y = param3;
         var_3514 = param4;
         if(!_loaded)
         {
            return;
         }
         updateDisplay();
      }
      
      public function get height() : Number
      {
         return _asset.height;
      }
      
      protected function updateDisplay() : void
      {
         var _loc2_:* = null;
         var _loc5_:* = null;
         if(!var_659)
         {
            return;
         }
         var _loc4_:MovieClip = class_277.getMovieClip(_asset,["btnBuy"]);
         var _loc7_:MovieClip = class_277.getMovieClip(_asset,["btnCantBuy"]);
         var _loc3_:TextField = class_277.getTextField(_asset,["tItemDescription"]);
         var _loc6_:TextField = class_277.getTextField(_asset,["tPurchaseDescription"]);
         var _loc1_:MovieClip = class_277.getMovieClip(_asset,["mcIcon"]);
         ButtonManager.attach(_loc4_,var_3514,null,"STORE.buyItem_" + var_1237,"itemBuy",{"itemcode":var_1237});
         ButtonManager.attach(_loc7_,var_3514,null,"STORE.cantBuyItem_" + var_1237,"itemBuy",{"itemcode":var_1237});
         ButtonManager.setEnabled(_loc7_,false,true);
         class_277.setTextOn(_loc7_,["tText"],BPResourceManager.getString("bp-flash","building_popupoptions_button_cantbuy"));
         ButtonManager.setEnabled(_loc4_,var_659.var_2623,!var_659.var_2623);
         _loc4_.visible = var_659.var_2623;
         _loc7_.visible = !var_659.var_2623;
         var _loc8_:* = var_659.var_2623?1:0.3;
         _loc3_.alpha = _loc8_;
         _loc8_ = _loc8_;
         _loc6_.alpha = _loc8_;
         _loc1_.alpha = _loc8_;
         _loc3_.htmlText = var_659.body;
         _loc6_.htmlText = var_659.var_5745;
         class_277.setTextOn(_loc4_,["tCost"],var_659.cost);
         class_277.setTextOn(_loc4_,["tText"],var_659.var_3866);
         if(var_659.cost.indexOf("FREE") > -1)
         {
            class_277.setProperties(_loc4_,["icon"],{"visible":false});
            class_277.setTextOn(_loc4_,["tText"],BPResourceManager.getString("bp-flash","building_popupoptions_button_instant"));
         }
         else
         {
            class_277.setProperties(_loc4_,["icon"],{"visible":true});
         }
         class_277.gotoAndStop(_loc4_,["icon"],var_659.currency);
         class_277.getMovieClip(_asset,["mcRule"]).visible = true;
         _loc1_.gotoAndStop(var_1237);
         if(var_1237.indexOf("PRO") > -1)
         {
            _loc2_ = class_277.getTextField(_asset,["mcIcon","tDuration"]);
            _loc5_ = "";
            _loc8_ = var_1237;
            if("PRO1" !== _loc8_)
            {
               if("PRO2" !== _loc8_)
               {
                  if("PRO3" === _loc8_)
                  {
                     _loc5_ = "28" + BPResourceManager.getString("bp-flash","date_time_short_day");
                  }
               }
               else
               {
                  _loc5_ = "7" + BPResourceManager.getString("bp-flash","date_time_short_day");
               }
            }
            else
            {
               _loc5_ = "24" + BPResourceManager.getString("bp-flash","date_time_short_hour");
            }
            class_277.setTextOnTextField(_loc2_,_loc5_);
         }
         _asset.x = _x;
         _asset.y = _y;
      }
   }
}
