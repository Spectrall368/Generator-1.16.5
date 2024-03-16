if(${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).openContainer instanceof Supplier && ((Supplier) ((PlayerEntity) ${input$entity}).openContainer).get() instanceof Map) {
	ItemStack stack=((Slot) ((Map) ((Supplier) ((PlayerEntity) ${input$entity}).openContainer).get()).get(${opt.toInt(input$slotid)})).getStack();
    if(stack != null) {
    	if(stack.attemptDamageItem(${opt.toInt(input$amount)},new Random(),null)){
    		stack.shrink(1);
    		stack.setDamage(0);
		}
    	((PlayerEntity) ${input$entity}).openContainer.detectAndSendChanges();
    }
}
