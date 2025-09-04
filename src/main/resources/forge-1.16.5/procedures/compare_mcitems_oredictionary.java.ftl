<#include "mcelements.ftl">
<#include "mcitems.ftl">
(${mappedMCItemToItemStackCode(input$a, 1)}.isIn(ItemTags.createOptional(${toResourceLocation(input$b)})))