<#include "mcitems.ftl">
/*@float*/(${mappedMCItemToItem(input$item)}.isFood() ? ${mappedMCItemToItem(input$item)}.getFood().getSaturation() : 0)
