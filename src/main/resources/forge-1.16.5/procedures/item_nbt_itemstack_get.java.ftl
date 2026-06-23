<#include "mcitems.ftl">
/*@ItemStack*/(ItemStack.read(${mappedMCItemToItemStackCode(input$item, 1)}.getOrCreateTag().copy().getCompound(${input$tagName})))