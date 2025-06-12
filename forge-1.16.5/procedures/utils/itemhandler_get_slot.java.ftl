private static ItemStack getItemStackFromItemStackSlot(int slotID, ItemStack itemStack) {
	AtomicReference<ItemStack> result = new AtomicReference<>(ItemStack.EMPTY);
	itemStack.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null)
		    .ifPresent(capability -> result.set(capability.getStackInSlot(slotID).copy()));

	return result.get();
}