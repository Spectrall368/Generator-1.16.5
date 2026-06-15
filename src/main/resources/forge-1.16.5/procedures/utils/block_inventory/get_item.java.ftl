private static ItemStack itemFromBlockInventory(IWorld world, BlockPos pos, int slot) {
    AtomicReference<ItemStack> result = new AtomicReference<>(ItemStack.EMPTY);
    TileEntity entity = world.getTileEntity(pos);
    if (entity != null)
		entity.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null)
		    .ifPresent(capability -> result.set(capability.getStackInSlot(slot)));

	return result.get();
}