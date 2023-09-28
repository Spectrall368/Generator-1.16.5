<#include "mcitems.ftl">
/*@int*/(${mappedMCItemToItem(input$item)} instanceof TieredItem ? ${mappedMCItemToItem(input$item)}.getTier().getLevel() : 0)
