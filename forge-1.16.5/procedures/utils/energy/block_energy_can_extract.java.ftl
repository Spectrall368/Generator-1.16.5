private static boolean canExtractEnergy(IWorld level, BlockPos pos, Direction direction) {
    AtomicBoolean result = new AtomicBoolean(false);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null)
        entity.getCapability(CapabilityEnergy.ENERGY, direction)
		    .ifPresent(capability -> result.set(capability.canExtract()));

	return result.get();
}