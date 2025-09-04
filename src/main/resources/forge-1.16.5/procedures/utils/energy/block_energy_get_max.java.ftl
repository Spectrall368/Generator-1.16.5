public static int getMaxEnergyStored(IWorld level, BlockPos pos, Direction direction) {
    AtomicInteger result = new AtomicInteger(0);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null)
        entity.getCapability(CapabilityEnergy.ENERGY, direction)
		    .ifPresent(capability -> result.set(capability.getMaxEnergyStored()));

	return result.get();
}