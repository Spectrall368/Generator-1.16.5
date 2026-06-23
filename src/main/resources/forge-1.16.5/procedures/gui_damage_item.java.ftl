if(${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).openContainer instanceof ${JavaModName}Menus.MenuAccessor) {
	Slot _slot = ((${JavaModName}Menus.MenuAccessor) ((PlayerEntity) ${input$entity}).openContainer).getSlots().get(${opt.toInt(input$slotid)});
	ItemStack stack = _slot.getStack();
	if (stack != null && !stack.isEmpty()) {
		if(stack.attemptDamageItem(${opt.toInt(input$amount)}, new Random(), null)) {
			stack.shrink(1);
			stack.setDamage(0);
		}
		_slot.putStack(stack);
		_slot.onSlotChanged();
		((PlayerEntity) ${input$entity}).openContainer.detectAndSendChanges();
	}
}