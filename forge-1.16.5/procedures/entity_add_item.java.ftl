<#include "mcitems.ftl">
if (${input$entity} instanceof PlayerEntity) {
	ItemStack _setstack = ${mappedMCItemToItemStackCode(input$item, 1)}.copy();
	_setstack.setCount(${opt.toInt(input$amount)});
	ItemHandlerHelper.giveItemToPlayer(((PlayerEntity) ${input$entity}), _setstack);
}
