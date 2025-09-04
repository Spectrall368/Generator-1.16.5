<#include "mcitems.ftl">
(${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).getCooldownTracker().hasCooldown(${mappedMCItemToItem(input$item)}))