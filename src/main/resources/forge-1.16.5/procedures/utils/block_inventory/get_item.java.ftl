private static ItemStack itemFromBlockInventory(IWorld level, BlockPos pos, int slot) {
    AtomicReference<ItemStack> result = new AtomicReference<>(ItemStack.EMPTY);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null)
		entity.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null)
		    .ifPresent(capability -> result.set(capability.getStackInSlot(slot)));

	return result.get();
}