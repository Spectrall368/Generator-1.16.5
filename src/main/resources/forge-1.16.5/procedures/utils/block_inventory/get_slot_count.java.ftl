private static int getBlockInventorySlotCount(IWorld world, BlockPos pos) {
    AtomicReference<Integer> result = new AtomicReference<>(0);
    TileEntity entity = world.getTileEntity(pos);
    if (entity != null)
		entity.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null)
		    .ifPresent(capability -> result.set(capability.getSlots()));

	return result.get();
}