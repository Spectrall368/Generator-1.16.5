if(${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).openContainer instanceof ${JavaModName}Menus.MenuAccessor) {
	ItemStack stack = ((${JavaModName}Menus.MenuAccessor) ((PlayerEntity) ${input$entity}).openContainer).getSlots().get(${opt.toInt(input$slotid)}).getStack();
	if(stack != null) {
		if(stack.attemptDamageItem(${opt.toInt(input$amount)}, new Random(), null)) {
			stack.shrink(1);
			stack.setDamage(0);
		}
		((PlayerEntity) ${input$entity}).openContainer.detectAndSendChanges();
	}
}