if(${input$entity} instanceof PlayerEntity) {
	Container _current = ((PlayerEntity) ${input$entity}).openContainer;
	if(_current instanceof Supplier) {
		Object invobj = ((Supplier) _current).get();
		if(invobj instanceof Map) {
			ItemStack stack=((Slot) ((Map) invobj).get((int)(${input$slotid}))).getStack();
    		if(stack != null) {
    			if(stack.attemptDamageItem((int) ${input$amount},new Random(),null)){
    				stack.shrink(1);
    				stack.setDamage(0);
				}
    			_current.detectAndSendChanges();
    		}
		}
	}
}
