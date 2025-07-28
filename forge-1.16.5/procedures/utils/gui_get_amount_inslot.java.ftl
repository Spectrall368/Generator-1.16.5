private static int getAmountInGUISlot(Entity entity, int sltid) {
	if(entity instanceof PlayerEntity && ((PlayerEntity) entity).openContainer instanceof ${JavaModName}Menus.MenuAccessor) {
		ItemStack stack = ((${JavaModName}Menus.MenuAccessor) ((PlayerEntity) ${input$entity}).openContainer).getSlots().get(sltid).getItem();
		if(stack != null)
			return stack.getCount();
	}
	return 0;
}