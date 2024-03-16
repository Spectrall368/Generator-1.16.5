<#include "mcitems.ftl">
if(${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).openContainer instanceof Supplier && ((Supplier) ((PlayerEntity) ${input$entity}).openContainer).get() instanceof Map) {
	ItemStack _setstack = ${mappedMCItemToItemStackCode(input$item, 1)}.copy();
	_setstack.setCount(${opt.toInt(input$amount)});
	((Slot) ((Map) ((Supplier) ((PlayerEntity) ${input$entity}).openContainer).get()).get(${opt.toInt(input$slotid)})).putStack(_setstack);
	((PlayerEntity) ${input$entity}).openContainer.detectAndSendChanges();
}
