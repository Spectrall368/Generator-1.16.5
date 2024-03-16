<#include "mcelements.ftl">
if (world instanceof World) {
    BlockPos _bp = ${toBlockPos(input$x,input$y,input$z)};
    if (BoneMealItem.applyBonemeal(new ItemStack(Items.BONE_MEAL), ((World) world), _bp) || BoneMealItem.growSeagrass(new ItemStack(Items.BONE_MEAL), ((World) world), _bp, null)) {
    if(!((World) world).isRemote())
    	((World) world).playEvent(2005, _bp, 0);
    }
}
