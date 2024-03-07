<#include "mcitems.ftl">
if(${input$entity} instanceof PlayerEntity)
	((PlayerEntity) ${input$entity}).getCooldownTracker().setCooldown(${mappedMCItemToItem(input$item)}, ${opt.toInt(input$ticks)});
