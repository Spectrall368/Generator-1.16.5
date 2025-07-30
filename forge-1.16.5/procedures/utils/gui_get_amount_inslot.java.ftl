private static int getAmountInGUISlot(Entity entity, int sltid) {
	if(entity instanceof PlayerEntity && ((PlayerEntity) entity).openContainer instanceof ${JavaModName}Menus.MenuAccessor) {
		ItemStack stack = ((${JavaModName}Menus.MenuAccessor) ((PlayerEntity) entity).openContainer).getSlots().get(sltid).getStack();
		if(stack != null)
			return stack.getCount();
	}
	return 0;
}