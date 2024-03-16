/*@int*/(new Object(){
	public int getAmount(int sltid) {
		if(${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).openContainer instanceof Supplier && ((Supplier) ((PlayerEntity) ${input$entity}).openContainer).get() instanceof Map) {
			ItemStack stack = ((Slot) ((Map) ((Supplier) ((PlayerEntity) ${input$entity}).openContainer).get()).get(sltid)).getStack();
			if(stack != null)
				return stack.getCount();
		}
		return 0;
	}
}.getAmount(${opt.toInt(input$slotid)}))
