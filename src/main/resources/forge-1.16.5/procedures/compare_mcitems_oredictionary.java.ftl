<#include "mcelements.ftl">
<#include "mcitems.ftl">
(${mappedMCItemToItem(input$a, 1)}.isIn(ItemTags.createOptional(${toResourceLocation(input$b)})))