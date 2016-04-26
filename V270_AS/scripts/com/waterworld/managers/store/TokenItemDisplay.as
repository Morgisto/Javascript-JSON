package com.waterworld.managers.store
{
   import package_151.TokenVO;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import com.waterworld.utils.movieclip.class_277;
   import com.waterworld.managers.currency.CurrencyDataManager;
   import flash.display.Bitmap;
   import com.waterworld.display.ButtonManager;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.display.text.class_140;
   
   public class TokenItemDisplay extends StoreItemDisplay
   {
       
      private var var_891:TokenVO;
      
      private var _log:Object;
      
      private var _enabled:Boolean;
      
      private var var_3878:String;
      
      public function TokenItemDisplay(param1:String = "AssetTokenItem")
      {
         super(param1);
      }
      
      public function setToken(param1:TokenVO, param2:int, param3:int, param4:Boolean, param5:Function = null, param6:Object = null) : void
      {
         _enabled = param4;
         var_891 = param1;
         _log = param6;
         setCommonItem("SPT",param2,param3,param5);
      }
      
      override protected function updateDisplay() : void
      {
         if(!var_891)
         {
            return;
         }
         var useButton:MovieClip = class_277.getMovieClip(_asset,["btnUse"]);
         var itemDescription:TextField = class_277.getTextField(_asset,["tItemDescription"]);
         var buyDescription:TextField = class_277.getTextField(_asset,["tPurchaseDescription"]);
         var icon:MovieClip = class_277.getMovieClip(_asset,["iconGuide"]);
         if(var_3878 != var_891.type)
         {
            if(var_3878 != null)
            {
               icon.removeChildren();
            }
            CurrencyDataManager.getInstance().getIcon(var_891,function(param1:Bitmap):void
            {
               icon.addChild(param1);
               var_3878 = var_891.type;
            });
         }
         ButtonManager.attach(useButton,var_3514,BPResourceManager.getString("bp-flash","token_use"),"STORE.useToken_" + var_891.id,"useToken",{
            "itemcode":var_1237,
            "token":var_891,
            "log":_log
         });
         ButtonManager.setEnabled(useButton,_enabled,!_enabled);
         var _loc2_:* = _enabled?1:0.3;
         itemDescription.alpha = _loc2_;
         _loc2_ = _loc2_;
         buyDescription.alpha = _loc2_;
         icon.alpha = _loc2_;
         class_140.setAutoShrinkText(itemDescription,var_891.name,itemDescription.width,itemDescription.height);
         class_140.setAutoShrinkText(buyDescription,var_891.timeDescription,buyDescription.width,buyDescription.height);
         _asset.x = _x;
         _asset.y = _y;
      }
   }
}
