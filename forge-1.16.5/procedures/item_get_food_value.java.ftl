<#include "mcitems.ftl">
/*@int*/(${mappedMCItemToItem(input$item)}.isFood() ? ${mappedMCItemToItem(input$item)}.getFood().getHealing() : 0)
