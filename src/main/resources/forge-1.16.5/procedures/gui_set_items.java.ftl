<#include "mcitems.ftl">
<@head>if (${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).openContainer instanceof ${JavaModName}Menus.MenuAccessor) {</@head>
	ItemStack _setstack${cbi} = ${mappedMCItemToItemStackCode(input$item, 1)}.copy();
	_setstack${cbi}.setCount(${opt.toInt(input$amount)});
	((${JavaModName}Menus.MenuAccessor) ((PlayerEntity) ${input$entity}).openContainer).getSlots().get(${opt.toInt(input$slotid)}).putStack(_setstack${cbi});
<@tail>
	((PlayerEntity) ${input$entity}).openContainer.detectAndSendChanges();
}</@tail>