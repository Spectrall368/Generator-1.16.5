<#include "mcitems.ftl">
(world instanceof World ? ((World) world).getRecipeManager().getRecipe(IRecipeType.SMELTING, new Inventory(${mappedMCItemToItemStackCode(input$item, 1)}), ((World) world)).isPresent():false)
