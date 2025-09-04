<#include "mcitems.ftl">
/*@ItemStack*/(EnchantmentHelper.addRandomEnchantment(world.getRandom(), ${mappedMCItemToItemStackCode(input$item, 1)}, ${opt.toInt(input$levels)}, ${input$treasure}))
