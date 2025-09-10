<#include "mcelements.ftl">
<#include "mcitems.ftl">
(${mappedMCItemToItem(input$a)}.isIn(ItemTags.createOptional(${toResourceLocation(input$b)})))