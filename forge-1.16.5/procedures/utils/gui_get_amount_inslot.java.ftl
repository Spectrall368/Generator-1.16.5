private static int getAmountInGUISlot(Entity entity, int sltid) {
	if(entity instanceof PlayerEntity && ((PlayerEntity) entity).openContainer instanceof Supplier && ((Supplier) ((PlayerEntity) entity).openContainer).get() instanceof Map) {
		ItemStack stack = ((Slot) ((Map) ((Supplier) ((PlayerEntity) entity).openContainer).get()).get(sltid)).getStack();
		if(stack != null)
			return stack.getCount();
	}
	return 0;
}