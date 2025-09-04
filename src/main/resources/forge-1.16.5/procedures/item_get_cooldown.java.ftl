<#include "mcitems.ftl">
/*@float*/(${input$entity} instanceof PlayerEntity ? ((PlayerEntity) ${input$entity}).getCooldownTracker().getCooldown(${mappedMCItemToItem(input$item)}, 0f) * 100 : 0)