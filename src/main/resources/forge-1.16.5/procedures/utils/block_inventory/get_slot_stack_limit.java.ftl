private static int getBlockInventorySlotStackLimit(IWorld world, BlockPos pos, int slotId) {
    AtomicReference<Integer> result = new AtomicReference<>(0);
    TileEntity entity = world.getTileEntity(pos);
    if (entity != null && slotId >= 0)
		entity.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null)
		    .ifPresent(capability -> { if(slotId < capability.getSlots()) result.set(capability.getSlotLimit(slotId));});

	return result.get();
}