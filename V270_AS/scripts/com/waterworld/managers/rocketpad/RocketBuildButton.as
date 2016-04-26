package com.waterworld.managers.rocketpad
{
   import package_97.ResearchButton;
   import com.waterworld.utils.movieclip.class_277;
   import com.waterworld.core.GLOBAL;
   import package_40.RocketInventoryManager;
   import com.waterworld.utils.ReturnStatus;
   import flash.text.TextField;
   import com.waterworld.display.TooltipManager;
   import com.waterworld.ui.ComponentTooltip;
   
   public class RocketBuildButton extends ResearchButton
   {
       
      public function RocketBuildButton(param1:int, param2:Boolean = false, param3:Function = null)
      {
         super(param1,param2,param3);
      }
      
      override public function setup() : void
      {
         super.setup();
         class_277.setProperties(_asset,["tStatus"],{"visible":false});
      }
      
      override public function update(param1:Object = null) : void
      {
         super.update();
         var _loc5_:RocketInventoryManager = GLOBAL.rocketInventory;
         var _loc2_:ReturnStatus = _loc5_.canBuildRocket(var_5.id);
         var _loc3_:int = _loc5_.getNumRocketsOfType(var_5.id);
         if(_loc2_.isError)
         {
            showLocked();
         }
         else
         {
            showUnlocked();
         }
         var _loc4_:TextField = class_277.getTextField(_asset,["tWeight"]);
         if(_loc3_)
         {
            class_277.setTextOnTextField(_loc4_,_loc3_.toString() + "x");
            _loc4_.visible = true;
         }
         else
         {
            _loc4_.visible = false;
         }
         TooltipManager.getInstance().addDynamicVisualTooltip(this,ComponentTooltip.showDynamicForComp(var_5),true);
      }
      
      public function destroy() : void
      {
         TooltipManager.getInstance().removeTooltip(this);
      }
   }
}
